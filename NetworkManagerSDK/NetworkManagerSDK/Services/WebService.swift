//
//  WebService.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import UIKit
import Foundation

/// WebService implementa las funciones para las llamadas a servicios
/// Una instancia de esta clase dará acceso a las funciones para obtención de datos desde Servicio
public class WebService {
    /// Notificación de estatus de llamada a servicio (start / finish)
    public var callbackServices: ((ServicesPlugInResponse) -> Void)?
    private var environment: Environment
    private var appVersion: String
    
    /// Inicializador
    /// - Parameters:
    ///   - environment: Parametro del entorno a consultar
    ///   - appVersion: Versión de compilcación de la app
    public init(environment: Environment = .pr, appVersion: String) {
        self.environment = environment
        self.appVersion = appVersion
    }
    
    // MARK: - ⚠️ Métodos genericos ::::::::::::::::
    /// Función para obtener la información del CDN
    /// - Parameters:
    ///   - printResponse: Bandera para imprimir log de la petición
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
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                    }else{
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noFile.errorDescription
                        callback(false, error)
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    }
                }catch{
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    callback(false, error)
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                }
            }else if let error = failure{
                callback(false, error)
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            }
        }
    }
    
    /// Función para solicitar una petición de una API
    /// - Parameters:
    ///   - target: Servicio a consultar
    ///   - callback: ServiceClass (⎷ response "Catálogo de Classes") / ErrorResponseGral (⌀ error)
    public func fetchData(target: ServiceName, callback: @escaping CallbackResponseTarget) {    
        self.callbackServices?(ServicesPlugInResponse(.start))
        guard let service = Network.fetchConfigurationFile(name: K.pListName, key: target) else {
            let error = ErrorResponse()
            error.statusCode = -3
            error.responseCode = -3
            error.errorMessage = CustomError.noFile.errorDescription
            callback(nil, error)
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            return
        }
        
        switch target{
        case .version:
            callback(.version(service), nil)
        case .widget:
            break
        case .captchaIos(let ver):
            break
        }
        
        self.callbackServices?(ServicesPlugInResponse(.finish))
    }
    
}
    
