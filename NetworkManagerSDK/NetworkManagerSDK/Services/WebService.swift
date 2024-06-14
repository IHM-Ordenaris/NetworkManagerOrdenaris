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
        
        if let _ = service.valores{
            service.valores!.append(contentsOf: self.headers)
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
        case .listaRecurrentes(let phoneNumber):
            self.callServiceRecurrencias(&service, phoneNumber, printResponse, callback)
        case let .cancelarRecurrente(phoneNumber, uuid):
            self.callServiceCancelarRecurrencias(&service, phoneNumber, uuid, printResponse, callback)
        case let .suscripcionPush(token, phoneNumber):
            self.callServicePush(service, token, phoneNumber, printResponse, callback)
        case .desuscripcionPush(let info):
            self.callServiceCancelPush(service, with: info, printResponse: printResponse, callback)
        case .ofertasInternacionales:
            self.callServiceOfertas(service, printResponse, callback)
        }
    }
    
    private func callServicePaySafe(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = PagoSeguroRequest(uuid: K.uuidPaymentiOS)
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let paymentSafe = try JSONDecoder().decode(PagoSeguroResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.pagoSeguro(paymentSafe), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.pagoSeguro(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.pagoSeguro(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.pagoSeguro(nil), error)
        }
    }
    
    private func callServiceWidget(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let widgetService = try JSONDecoder().decode(WidgetServiceResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.widget(widgetService), nil)
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.widget(nil), error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.widget(nil), error)
            }
        }
    }
    
    private func callServiceCaptcha(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let captcha = try JSONDecoder().decode(CaptchaResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.captchaIos(captcha), nil)
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.captchaIos(nil), error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.captchaIos(nil), error)
            }
        }
    }
    
    private func callServiceRecurrencias(_ service: inout Servicio, _ phoneNumber: String ,_ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = RecurrenciasActivasRequest(identificador: phoneNumber)
        service.url = service.url?.replacingOccurrences(of: "#canal#", with: K.uuidPaymentiOS)
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let recurrencias = try JSONDecoder().decode(RecurrenciasActivasResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.listaRecurrentes(recurrencias), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.listaRecurrentes(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.listaRecurrentes(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.listaRecurrentes(nil), error)
        }
    }
    
    private func callServiceCancelarRecurrencias(_ service: inout Servicio, _ phoneNumber: String , _ uuid: String, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = RecurrenciasActivasRequest(identificador: phoneNumber)
        service.url = service.url?.replacingOccurrences(of: "#recurrencia#", with: uuid)
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let cancelarRecurrencia = try JSONDecoder().decode(DefaulResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cancelarRecurrente(cancelarRecurrencia), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.cancelarRecurrente(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.cancelarRecurrente(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.cancelarRecurrente(nil), error)
        }
    }
    
    private func callServicePush(_ service: Servicio, _ token: String, _ identificador: String?, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = SubscripcionPushRequest(informacion: InformacionClientePush(token: token, identificador: nil, listaTemas: nil))
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(Dictionary<String, Bool>.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.suscripcionPush(success["success"] ?? false), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.suscripcionPush(false), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.suscripcionPush(false), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.suscripcionPush(false), error)
        }
    }
    
    private func callServiceCancelPush(_ service: Servicio, with info: InformacionClientePush, printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = SubscripcionPushRequest(informacion: info)
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(Dictionary<String, Bool>.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.desuscripcionPush(success["success"] ?? false), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.desuscripcionPush(false), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.desuscripcionPush(false), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.desuscripcionPush(false), error)
        }
    }
    
    private func callServiceOfertas(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let recargaInternacional = try JSONDecoder().decode(RecargaInternacionalResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertasInternacionales(recargaInternacional), nil)
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = -2
                    error.responseCode = -2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.ofertasInternacionales(nil), error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.ofertasInternacionales(nil), error)
            }
        }
    }
}
    
//let success = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
