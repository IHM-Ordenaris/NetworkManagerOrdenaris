//
//  ExtWebService.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 17/06/24.
//

import Foundation

extension WebService{
    internal func callServicePaySafe(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceWidget(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceCaptcha(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceRecurrencias(_ service: inout Servicio, _ body: RecurrenciasActivasRequest ,_ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceCancelarRecurrencias(_ service: inout Servicio, _ body: RecurrenciasActivasRequest , _ uuid: String, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServicePush(_ service: Servicio, _ info: InformacionClientePush, printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = SubscripcionPushRequest(informacion: info)
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
    
    internal func callServiceCancelPush(_ service: Servicio, _ info: InformacionClientePush, printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceOfertas(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
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
    
    internal func callServiceDeleteAccount(_ service: Servicio, _ body: EliminacionRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaulResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.eliminacion(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.eliminacion(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.eliminacion(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.eliminacion(nil), error)
        }
    }
    
    internal func callServiceUserData<T>(_ service: Servicio, _ body: T, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) where T: Encodable {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let userData = try JSONDecoder().decode(UsuarioResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.datosUsuario(userData), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = -2
                        error.responseCode = -2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.datosUsuario(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.datosUsuario(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = -2
            error.responseCode = -2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.datosUsuario(nil), error)
        }
    }
}
