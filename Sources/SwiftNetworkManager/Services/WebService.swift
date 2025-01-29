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
public class WebService: @unchecked Sendable {
    /// Notificación de estatus de llamada a servicio (start / finish)
    public var callbackServices: ((ServicesPlugInResponse) -> Void)?
    private var environment: Environment
    var headers = [
        Headers(name: Cons.origen, value: Cons.origenValue),
        Headers(name: Cons.origin, value: Cons.origenValue)
    ]
    internal var version: String?
    
    /// Inicializador
    /// - Parameters:
    ///   - environment: Parametro del entorno a consultar (Por default, la propiedad será a Producción)
    ///   - appVersion: Versión de compilcación de la app
    public init(environment: Environment = .pr, appVersion: String) {
        self.environment = environment
        self.headers.append(Headers(name: Cons.app, value: appVersion))
    }
    
    // MARK: - ⚠️ Métodos genericos ::::::::::::::::
    /// Función para obtener la información del CDN
    /// - Parameters:
    ///   - printResponse: Bandera para imprimir log de la petición
    ///   - callback: ObjResponse (⎷ response) / ErrorResponseGral (⌀ error)
    public func loadConfiguration(printResponse: Bool = false, callback: @escaping CallbackResponseLoadSetting) {
        self.callbackServices?(ServicesPlugInResponse(.start))
        var headersCopy = self.headers
        headersCopy.append(Headers(name: Cons.ordServicio, value: Cons.ordServicioValue))
        let service = Servicio(name: "CDN", method: HTTPMethod.get.rawValue, headers: headersCopy, url: ProductService.Endpoint.CDN(environment: self.environment).url)
        Network.callNetworking(servicio: service, params: ["rnd": Date().timeIntervalSinceReferenceDate.description], printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let services = try JSONDecoder().decode([MainServicio].self, from: data)
                    var targets: Dictionary<String, Servicio> = Dictionary<String, Servicio>()
                    for target in services{
                        target.services.forEach {
                            targets[$0.name] = $0
                        }
                    }
                    if Network.setConfigurationFile(name: Cons.pListName, targets) {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(true, nil)
                    }else {
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage:  CustomError.noFile.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(false, error)
                    }
                }catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(false, error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
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
        guard var service = Network.fetchConfigurationFile(name: Cons.pListName, key: target) else {
            let error = ErrorResponse(statusCode: -3, responseCode: -3, errorMessage: CustomError.noFile.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(nil, error)
            return
        }
        
        if let headers = service.headers, !headers.isEmpty{
            service.headers!.append(contentsOf: self.headers)
        }else{
            service.headers = self.headers
        }
        
        switch target {
        case .pagoSeguro:
            self.callServicePaySafe(service, printResponse, callback)
        case .widget:
            self.callServiceWidget(service, printResponse, callback)
        case let .validarBait(number, action):
            self.callServiceValidateBait(service, number, action, printResponse, callback)
        case .perfilGaleria:
            callback(.perfilGaleria(service.headers), nil)
        case .perfilCamara:
            callback(.perfilCamara(service.headers), nil)
        case .escaneo:
            callback(.escaneo(service.headers), nil)
        case .version(let params):
            self.callServiceInfoAppStore(service, params, printResponse, callback)
        case .listaRecurrentes(let params):
            self.callServiceRecurrencias(&service, params, printResponse, callback)
        case let .cancelarRecurrente(phoneNumber, uuid):
            self.callServiceCancelarRecurrencias(&service, phoneNumber, uuid, printResponse, callback)
        case .suscripcionPush(let params):
            self.callServicePush(service, params, printResponse, callback)
        case .desuscripcionPush(let params):
            self.callServiceCancelPush(service, params, printResponse, callback)
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
        case .solicitudOtp(let params):
            self.callServiceSendOTP(service, params, printResponse, callback)
        case .verificarOtp(let params):
            self.callServiceValidateOTP(service, params, printResponse, callback)
        case .consumo(let params):
            self.callServiceMobileHostpot(service, params, printResponse, callback)
        case .newConsumo(let replaceParams):
            self.callServiceConsumption(&service, replaceParams, printResponse, callback)
        case .ofertas(let update), .ofertasSams(let update), .asociados(let update):
            self.callServiceOffer(key: target, forceUpdate: update, service, printResponse, callback)
        case .validarImei(let imei):
            self.callServiceValidate(service, imei, printResponse, callback)
        case .solicitudPortabilidad(let params):
            self.callServicePortability(service, params, printResponse, callback)
        case .redencionTicket(let params):
            self.callServiceTicket(service, params, printResponse, callback)
        case .cerrarSesion(let params):
            self.callServiceLogOut(service, params, printResponse, callback)
        case .solicitudReemplazoSim(let params):
            self.callServiceReplaceSim(service, params, printResponse, callback)
        case .enviarOtpReemplazoSim(let params):
            self.callServiceSendOtpReplaceSim(service, params, printResponse, callback)
        case let .validarOtpReemplazoSim(params, uuid):
            self.callServiceValidateOtpReplaceSim(service, params, uuidHeader: uuid, printResponse, callback)
        case .listaCodigoArea:
            self.callServiceCodeAreaList(service, printResponse, callback)
        case .enviarOtpNir(let params):
            self.callServiceSendOtpNir(service, params, printResponse, callback)
        case .validarOtpNir(let params):
            self.callServiceValidateOTPNir(service, params, printResponse, callback)
        case .cambiarNir(let params):
            self.callServiceUpdateNir(service, params, printResponse, callback)
        }
    }
}
    
//let success = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
