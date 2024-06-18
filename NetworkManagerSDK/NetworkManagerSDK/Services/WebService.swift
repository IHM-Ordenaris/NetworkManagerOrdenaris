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
    var headers = [
        Headers(nombre: K.origen, valor: K.origenValue),
        Headers(nombre: K.origin, valor: K.origenValue)
    ]
    
    /// Inicializador
    /// - Parameters:
    ///   - environment: Parametro del entorno a consultar (Por default, la propiedad será a Producción)
    ///   - appVersion: Versión de compilcación de la app
    public init(environment: Environment = .pr, appVersion: String) {
        self.environment = environment
        self.headers.append(Headers(nombre: K.app, valor: appVersion))
    }
    
    // MARK: - ⚠️ Métodos genericos ::::::::::::::::
    /// Función para obtener la información del CDN
    /// - Parameters:
    ///   - printResponse: Bandera para imprimir log de la petición
    ///   - callback: ObjResponse (⎷ response) / ErrorResponseGral (⌀ error)
    public func loadConfiguration(printResponse: Bool = false, callback: @escaping CallbackResponseLoadSetting) {
        self.callbackServices?(ServicesPlugInResponse(.start))
        var headersCopy = self.headers
        headersCopy.append(Headers(nombre: K.ordServicio, valor: K.ordServicioValue))
        let service = Servicio(nombre: "CDN", headers: true, method: HTTPMethod.get.rawValue, auto: nil, valores: headersCopy, url: ProductService.Endpoint.CDN(environment: self.environment).url)
        Network.callNetworking(servicio: service, params: ["rnd": Date().timeIntervalSinceReferenceDate.description], printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let services = try JSONDecoder().decode([MainServicio].self, from: data)
                    var targets: Dictionary<String, Servicio> = Dictionary<String, Servicio>()
                    for target in services{
                        target.servicios.forEach {
                            targets[$0.nombre] = $0
                        }
                    }
                    if Network.setConfigurationFile(name: K.pListName, targets) {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(true, nil)
                    }else {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noFile.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(false, error)
                    }
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(false, error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(false, error)
            }
        }
    }
    
    /// Función para solicitar una petición de una API
    /// - Parameters:
    ///   - target: Servicio a consultar
    ///   - printResponse: Bandera para imprimir log de la petición
    ///   - callback: ServiceClass (⎷ response "Catálogo de Classes") / ErrorResponseGral (⌀ error)
    public func fetchData(target: ServiceName, printResponse: Bool = false, callback: @escaping CallbackResponseTarget) {
        self.callbackServices?(ServicesPlugInResponse(.start))
        guard var service = Network.fetchConfigurationFile(name: K.pListName, key: target) else {
            let error = ErrorResponse()
            error.statusCode = -3
            error.responseCode = -3
            error.errorMessage = CustomError.noFile.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(nil, error)
            return
        }
        
        if let valores = service.valores, let isHeaders = service.headers, isHeaders, !valores.isEmpty{
            service.valores!.append(contentsOf: self.headers)
        }else{
            service.valores = self.headers
        }
        
        switch target {
        case .pagoSeguro:
            self.callServicePaySafe(service, printResponse, callback)
        case .widget:
            self.callServiceWidget(service, printResponse, callback)
        case .captchaIos:
            self.callServiceCaptcha(service, printResponse, callback)
        case .perfilGaleria:
            callback(.perfilGaleria(service.valores), nil)
        case .perfilCamara:
            callback(.perfilCamara(service.valores), nil)
        case .escaneo:
            callback(.escaneo(service.valores), nil)
        case .version:
            callback(.version(service.valores), nil)
        case .listaRecurrentes(let params):
            self.callServiceRecurrencias(&service, params, printResponse, callback)
        case let .cancelarRecurrente(phoneNumber, uuid):
            self.callServiceCancelarRecurrencias(&service, phoneNumber, uuid, printResponse, callback)
        case .suscripcionPush(let params):
            self.callServicePush(service, params, printResponse: printResponse, callback)
        case .desuscripcionPush(let params):
            self.callServiceCancelPush(service, params, printResponse: printResponse, callback)
        case .ofertasInternacionales:
            self.callServiceOfertas(service, printResponse, callback)
        case .eliminacion(let params):
            self.callServiceDeleteAccount(service, params, printResponse, callback)
        case .acceso(let params):
            self.callServiceUserData(service, params, printResponse, callback)
        case .cambiarPerfil(let params):
            self.callServiceUserData(service, params, printResponse, callback)
        case .cambiarPass(let params):
            self.callServiceUserData(service, params, printResponse, callback)
        case .reestablecerPassword(let params):
            self.callServiceUserData(service, params, printResponse, callback)
        case .registrarCuenta(let params):
            self.callServiceUserData(service, params, printResponse, callback)
        }
    }
}
    
//let success = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
