//
//  Network.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

/// Estructura con métodos DELETE,  GET,  POST y PUT para llamadas a servicios
struct Network {
    // MARK: - Petición GET
    /// Función genérica para peticion de servicios con método "GET"
    /// - Parameters:
    ///   - servicio: Objeto tipo Servicio
    ///   - params: Diccionario de paràmetros
    ///   - completion: CustomResponseObject (case response) / NSError (case failure)
    func methodGet(servicio: Servicio, params: Dictionary<String, Any>, completion: @escaping CallbackCustomResponse) {
        let url = URL(string: servicio.url)!
        let bodyDict = params
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !bodyDict.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyDict)
            request.httpBody = jsonData
        }
        if let headers = servicio.headers {
            for newheader in headers {
                request.setValue( newheader.valor, forHTTPHeaderField: newheader.nombre)
            }
        }
//        request.httpShouldHandleCookies = false
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("❌ Error en servicio \(servicio.nombre)")
                let err: ErrorResponse = ErrorResponse()
                switch error {
                case .some(let error as NSError) where error.code == NSURLErrorNotConnectedToInternet: // showOffline
                    err.statusCode = error.code
                    err.errorMessage = error.localizedDescription
                    completion(CustomResponseObject(), err)
                case .some(let error as NSError) where error.code == NSURLErrorTimedOut: // Timed Out
                    err.statusCode = error.code
                    err.errorMessage = error.localizedDescription
                    completion(CustomResponseObject(), err)
                case .some(let error as NSError): // showGenericError
                    completion(CustomResponseObject(), err)
                    err.statusCode = error.code
                    err.errorMessage = error.localizedDescription
                case .none:
                    completion(CustomResponseObject(), nil)
                }
                return
            }
            
            guard let responseG = response as? HTTPURLResponse, 200 ... 299  ~= responseG.statusCode else {
                DispatchQueue.main.async {
                    let err = ErrorResponse()
                    print("❌ Error en servicio \(servicio.nombre)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("::::::::: RESPONSE - String :::::::::\n \(responseString)")
                        var objResponse = CustomResponseObject()
                        objResponse.success = false
                        objResponse.data = data
                        let resp = response as! HTTPURLResponse
                        err.statusCode = resp.statusCode
                        completion(objResponse, err)
                    } else {
                        print("unable to parse response as string")
                        let err: ErrorResponse = ErrorResponse()
                        completion(CustomResponseObject(), err)
                    }
                }
                return
            }
            
            print("✅ Responde el servicio GET \(servicio.nombre)")
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    if servicio.printResponse {
                        print("RESPONSE:\n\(responseJSON)")
                    }
                    var objResponse = CustomResponseObject()
                    objResponse.success = true
                    objResponse.data = data
                    completion(objResponse, nil)
                }
            } else {
                // parsing json error
                DispatchQueue.main.async {
                    if servicio.printResponse {
                        print("\n\n\(responseG.description)")
                    }
                    if let responseString = String(data: data, encoding: .utf8) {
                        if servicio.printResponse {
                            print("\n\n::::::::: RESPONSE - String :::::::::\n \(responseString)")
                        }
                        var objResponse = CustomResponseObject()
                        objResponse.success = true
                        objResponse.data = data
                        completion(objResponse, nil)
                    } else {
                        print("unable to parse response as string")
                        let err: ErrorResponse = ErrorResponse()
                        completion(CustomResponseObject(), err)
                    }
                }
            }
        }
        print("Request a Servicio...")
        task.resume()
    }
}
