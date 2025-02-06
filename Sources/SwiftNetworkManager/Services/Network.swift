//
//  Network.swift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 10/06/24.
//

import Foundation

/// Estructura con métodos DELETE,  GET,  POST y PUT para llamadas a servicios
internal struct Network {
    // MARK: - Petición Networking
    /// Función genérica para peticion de servicios en general
    /// - Parameters:
    ///   - servicio: Objeto tipo Servicio
    ///   - params: Diccionario de parámetros
    ///   - printResponse: Bandera para imprimir log de la petición
    ///   - completion: CustomResponseObject (case response) / ErrorResponse (case failure)
    static func callNetworking(servicio: Servicio, params: Any?, _ printResponse: Bool, timeOut: Double? = nil, _ completion: @escaping CallbackCustomResponse) {
        guard Reachability.isConnectedToNetwork() else {
            let error = ErrorResponse(statusCode: -1, responseCode: -1, errorMessage: CustomError.noData.errorDescription)
            completion(nil, error)
            return
        }
        
        guard let urlString = servicio.url, var urlComps = URLComponents(string: urlString) else {
            let error = ErrorResponse(statusCode: Cons.error0, responseCode: Cons.error0, errorMessage: CustomError.noUrl.errorDescription)
            completion(nil, error)
            return
        }
        
        var body: Data?
        if let body = params as? Dictionary<String, String>{
            let queryItems: [URLQueryItem] = body.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            urlComps.queryItems = queryItems
        }else if let data = params as? Data{
            body = data
        }
        
        guard let url = urlComps.url else {
            let error = ErrorResponse(statusCode: Cons.error0, responseCode: Cons.error0, errorMessage: CustomError.noUrl.errorDescription)
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = servicio.method
        request.httpBody = body
        
        if let time = timeOut {
            request.timeoutInterval = TimeInterval(time)
        }
        
        if servicio.method == "POST"{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = servicio.headers {
            for newheader in headers {
                request.setValue(newheader.value, forHTTPHeaderField: newheader.name)
            }
        }
//        request.httpShouldHandleCookies = false
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request) {  data, response, error in
            guard let data = data else {
                print("❌ Error en servicio \(servicio.name)")
                var err: ErrorResponse?
                switch error {
                case .some(let error as NSError) where error.code == NSURLErrorNotConnectedToInternet: // showOffline
                    err = ErrorResponse(statusCode: error.code, responseCode: nil, errorMessage: error.localizedDescription)
                    completion(nil, err)
                case .some(let error as NSError) where error.code == NSURLErrorTimedOut: // Timed Out
                    err = ErrorResponse(statusCode: error.code, responseCode: nil, errorMessage: error.localizedDescription)
                    completion(nil, err)
                case .some(let error as NSError): // showGenericError
                    err = ErrorResponse(statusCode: error.code, responseCode: nil, errorMessage: error.localizedDescription)
                    completion(nil, err)
                case .none:
                    completion(nil, nil)
                }
                return
            }
            
            guard let responseG = response as? HTTPURLResponse, 200 ... 299  ~= responseG.statusCode else {
                DispatchQueue.main.async {
                    var err: ErrorResponse?
                    print("❌ Error en servicio \(servicio.name)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("::::::::: RESPONSE - String :::::::::\n \(responseString)")
                        var objResponse = CustomResponseObject()
                        objResponse.success = false
                        objResponse.data = data
                        objResponse.headers = nil
                        let resp = response as! HTTPURLResponse
                        var errorMsg: String?
                        do {
                            let defaultModel = try JSONDecoder().decode(DefaultResponse.self, from: data)
                            errorMsg = defaultModel.mensaje ?? defaultModel.message
                        } catch {
                            errorMsg = "Lo sentimos, este servicio no está disponible."
                        }
                        err = ErrorResponse(statusCode: resp.statusCode, responseCode: nil, errorMessage: errorMsg)
                        completion(objResponse, err)
                    } else {
                        print("unable to parse response as string")
                        let err: ErrorResponse = ErrorResponse(statusCode: Cons.error0, responseCode: Cons.error0, errorMessage: "")
                        completion(nil, err)
                    }
                }
                return
            }
            
            print("✅ Responde el servicio \(servicio.method ?? "") \(servicio.name)")
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    if printResponse {
                        print("RESPONSE:\n\(responseJSON)")
                    }
                    var objResponse = CustomResponseObject()
                    objResponse.success = true
                    objResponse.data = data
                    objResponse.headers = responseG.allHeaderFields
                    
                    completion(objResponse, nil)
                }
            } else {
                // parsing json error
                DispatchQueue.main.async {
                    if printResponse{
                        print("\n\n\(responseG.description)")
                    }
                    if let responseString = String(data: data, encoding: .utf8) {
                        if printResponse{
                            print("\n\n::::::::: RESPONSE - String :::::::::\n \(responseString)")
                        }
                        var objResponse = CustomResponseObject()
                        objResponse.success = true
                        objResponse.data = data
                        completion(objResponse, nil)
                    } else {
                        print("unable to parse response as string")
                        let err: ErrorResponse = ErrorResponse(statusCode: Cons.error0, responseCode: Cons.error0, errorMessage: "")
                        completion(nil, err)
                    }
                }
            }
        }
        print("Request a Servicio...")
        task.resume()
    }
    
    
    // MARK: - Utilidades
    /// Función para almacenar información en un plist, regresa una bandera booleana
    /// - Parameters:
    ///   - name: Nombre del archivo plist
    ///   - targets: Datos del CDN
    static func setConfigurationFile(name: String, _ targets: Dictionary<String, Servicio>) -> Bool{
        guard let url = URL(string: ProductService.Endpoint.file(name).url) else {
            return false
        }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(targets)
            try data.write(to: url)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Función para obtener la información de un plist y regresa un objeto del tipo "Servicio"
    /// - Parameters:
    ///   - name: Nombre del archivo plist
    ///   - key: Llave del target a obtener
    static func fetchConfigurationFile(name: String, key: ServiceName) -> Servicio?{
        guard let url = URL(string: ProductService.Endpoint.file(name).url) else {
            return nil
        }
        if let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            do {
                let target = try decoder.decode(Dictionary<String, Servicio>.self, from: data)
                return target[key.getKey]
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

