//
//  ExtWebService.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 17/06/24.
//

import Foundation

extension WebService{
    internal func callServicePaySafe(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = PagoSeguroRequest(uuid: Cons.uuidPaymentiOS)
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
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
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
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
        service.url = service.url?.replacingOccurrences(of: "#canal#", with: Cons.uuidPaymentiOS)
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
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
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
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
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.datosUsuario(nil), error)
        }
    }
    
    internal func callServiceSendOTP(_ service: Servicio, _ body: OTPRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaulResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudPIN(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudPIN(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.solicitudPIN(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.solicitudPIN(nil), error)
        }
    }
    
    internal func callServiceValidateOTP(_ service: Servicio, _ body: ValidateOtpRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(OTPResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.verificarPIN(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.verificarPIN(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.verificarPIN(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.verificarPIN(nil), error)
        }
    }
    
    internal func callServiceMobileHostpot(_ service: Servicio, _ body: MobileHotspotRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(MobileHotspotResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.consumo(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.consumo(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.consumo(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.consumo(nil), error)
        }
    }
    
    internal func callServiceOffer(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let widgetService = try JSONDecoder().decode(OffersResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertas(widgetService), nil)
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.ofertas(nil), error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.ofertas(nil), error)
            }
        }
    }
    
    internal func callServiceValidate(_ service: inout Servicio, imei:String, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        service.url = service.url?.appending(imei)
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let imeiService = try JSONDecoder().decode(ImeiResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.validarImei(imeiService), nil)
                }catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.validarImei(nil), error)
                }
            }else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.validarImei(nil), error)
            }
        }
    }
    
    internal func callServicePortability(_ service: Servicio, _ info: PortabilidadElementsRequest, printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = PortabilidadRequest(portabilidad: info)
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let portabilityService = try JSONDecoder().decode(PortabilityResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudPortabilidad(portabilityService), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudPortabilidad(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.solicitudPortabilidad(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.solicitudPortabilidad(nil), error)
        }
    }
    
    internal func callServiceTicket(_ service: Servicio, _ body: RedencionTicketRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let ticketService = try JSONDecoder().decode(RedencionTicketResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.redencionTicket(ticketService), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.redencionTicket(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.redencionTicket(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.redencionTicket(nil), error)
        }
    }
    
    internal func callServiceLogOut(_ service: Servicio, _ body: LogOutRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do{
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaulResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cerrarSesion(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.cerrarSesion(nil), error)
                    }
                }else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.cerrarSesion(nil), error)
                }
            }
        }catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.eliminacion(nil), error)
        }
    }
}
