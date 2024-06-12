//
//  WebService.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import UIKit
import Foundation

/// WebService implementa las funciones para las llamadas a servicios
/// Una instancia de esta clasedará acceso a las funciones para obtención de datos desde Servicio
public class WebService {
    /// Notificación de estatus de llamada a servicio (start / finish)
    public var callbackServices: ((ServicesPlugInResponse) -> Void)?
    private var environment: Environment
    private var appVersion: String
    
    public init(environment: Environment = .pr, appVersion: String) {
        /// Inicializador
        self.environment = environment
        self.appVersion = appVersion
    }
    
    // MARK: - ⚠️ Métodos GET ::::::::::::::::
    /// Función obtener status token device
    ///  ```
    /// func getCuentasById(idAccount:String, callback: { response, error in }
    /// ```
    /// - Parameters:
    ///   - callback: ObjResponse (⎷ response) / ErrorResponseGral (⌀ error)
    
    public func loadConfiguration(printResponse: Bool, callback: @escaping CallbackResponseLoadSetting){
        self.callbackServices?(ServicesPlugInResponse(.start))
        let headers = [
            Headers(nombre: K.ordServicio, valor: K.ordServicioValue),
            Headers(nombre: K.origen, valor: K.origenValue),
            Headers(nombre: K.origin, valor: K.origenValue),
            Headers(nombre: K.app, valor: self.appVersion)
        ]
        
        let service = Servicio(nombre: "CDN", headers: true, method: HTTPMethod.get.rawValue, auto: nil, valores: headers, url: ProductService.Endpoint.CDN(environment: self.environment).url)
        Network.methodGet(servicio: service, params: ["rnd": Date().timeIntervalSinceReferenceDate.description], printResponse) { response, failure in
            if let result = response, let data = result.data, result.success{
                do{
                    let services = try JSONDecoder().decode([MainServicio].self, from: data)
                    var targets: Dictionary<String, Servicio> = Dictionary<String, Servicio>()
                    for target in services{
                        target.servicios.forEach {
                            targets[$0.nombre] = $0
                        }
                    }
                    if Network.setConfigurationFile(name: K.pListName, targets){
                        callback(true, nil)
                    }else{
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noFile.errorDescription
                        callback(false, error)
                    }
                }catch{
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    callback(false, error)
                }
            }else if let error = failure{
                callback(false, error)
            }
        }
    }
    
    public func fetchData(target: ServiceName, callback: @escaping CallbackResponseGetCharacters) {
        self.callbackServices?(ServicesPlugInResponse(.start))
        let service = Network.fetchConfigurationFile(name: K.pListName, path: target)
        callback(service?.url, nil)
        
        /*Network().methodGet(servicio: service, params: params) { response, failure in
            if let error = failure {
                callback(ObjResponseGetCharacters(), error)
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                return
            } else {
                let decoder = JSONDecoder()
                do {
                    let datos = response!.data!
                    let decodedResponse = try decoder.decode(ObjResponseGetCharacters.self, from: datos)
                    callback(decodedResponse, nil)
                } catch {
                    callback(ObjResponseGetCharacters(), ErrorResponse())
                }
                self.callbackServices?(ServicesPlugInResponse(.finish))
            }
        }*/
    }
}
    
