//
//  ExtWebService.swift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 17/06/24.
//

import Foundation

extension WebService{
    internal func callServicePaySafe(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = PagoSeguroRequest(uuid: Cons.uuidPaymentiOS)
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let paymentSafe = try JSONDecoder().decode(PagoSeguroResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.pagoSeguro(paymentSafe), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.pagoSeguro(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.pagoSeguro(nil), error)
                }
            }
        } catch {
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
                } catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.widget(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.widget(nil), error)
            }
        }
    }
    
    internal func callServiceValidateBait(_ service: Servicio, _ number: String, _ action: ActionBait, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        var body : ValidateBaitRequest!
        switch action {
        case .portability:
            body = ValidateBaitRequest(dn: nil, iccid: number, accion: action.rawValue)
        default:
            body = ValidateBaitRequest(dn: number, iccid: nil, accion: action.rawValue)
        }
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            var serviceUpdate = service
            if let indexFormHeader = serviceUpdate.headers?.firstIndex(where: {
                $0.name == Cons.ordForm
            }) {
                serviceUpdate.headers?.remove(at: indexFormHeader)
                serviceUpdate.headers?.append(Headers(name: Cons.ordForm, value: Cons.ordFormValue))
            }
            Network.callNetworking(servicio: serviceUpdate, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let validateResponse = try JSONDecoder().decode(ValidateBaitResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarBait(validateResponse), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.validarBait(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.validarBait(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.validarBait(nil), error)
        }
    }
    
    internal func callServiceRecurrencias(_ service: inout Servicio, _ body: RecurrenciasActivasRequest ,_ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        service.url = service.url?.replacingOccurrences(of: "#canal#", with: Cons.uuidPaymentiOS)
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let recurrencias = try JSONDecoder().decode(RecurrenciasActivasResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.listaRecurrentes(recurrencias), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.listaRecurrentes(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.listaRecurrentes(nil), error)
                }
            }
        } catch {
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
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let cancelarRecurrencia = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cancelarRecurrente(cancelarRecurrencia), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.cancelarRecurrente(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.cancelarRecurrente(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.cancelarRecurrente(nil), error)
        }
    }
    
    internal func callServicePush(_ service: Servicio, _ info: InformacionClientePush, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = SubscripcionPushRequest(informacion: info)
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(Dictionary<String, Bool>.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.suscripcionPush(success["success"] ?? false), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.suscripcionPush(false), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.suscripcionPush(false), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.suscripcionPush(false), error)
        }
    }
    
    internal func callServiceCancelPush(_ service: Servicio, _ info: InformacionClientePush, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = SubscripcionPushRequest(informacion: info)
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(Dictionary<String, Bool>.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.desuscripcionPush(success["success"] ?? false), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.desuscripcionPush(false), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.desuscripcionPush(false), error)
                }
            }
        } catch {
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
                } catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.ofertasInternacionales(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.ofertasInternacionales(nil), error)
            }
        }
    }
    
    internal func callServiceDeleteAccount(_ service: Servicio, _ body: EliminacionRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.eliminacion(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.eliminacion(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.eliminacion(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.eliminacion(nil), error)
        }
    }
    
    internal func callServiceUserData<T>(_ service: Servicio, _ body: T, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) where T: Encodable {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let userData = try JSONDecoder().decode(UsuarioResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.datosUsuario(userData), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.datosUsuario(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.datosUsuario(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.datosUsuario(nil), error)
        }
    }
    
    internal func callServiceSendOTP(_ service: Servicio, _ body: OTPRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudOtp(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudOtp(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.solicitudOtp(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.solicitudOtp(nil), error)
        }
    }
    
    internal func callServiceValidateOTP(_ service: Servicio, _ body: ValidateOtpRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(OTPResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.verificarOtp(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.verificarOtp(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.verificarOtp(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.verificarOtp(nil), error)
        }
    }
    
    internal func callServiceMobileHostpot(_ service: Servicio, _ body: MobileHotspotRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(MobileHotspotResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.consumo(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.consumo(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.consumo(nil), error)
                }
            }
        } catch {
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
                } catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.ofertas(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.ofertas(nil), error)
            }
        }
    }
    
    internal func callServiceValidate(_ service: Servicio, _ body: ImeiRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let imeiService = try JSONDecoder().decode(ImeiResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarImei(imeiService), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.validarImei(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.validarImei(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.validarImei(nil), error)
        }
    }
    
    internal func callServicePortability(_ service: Servicio, _ body: PortabilidadElementsRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let body = PortabilidadRequest(portabilidad: body)
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let portabilityService = try JSONDecoder().decode(PortabilityResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudPortabilidad(portabilityService), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudPortabilidad(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.solicitudPortabilidad(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.solicitudPortabilidad(nil), error)
        }
    }
    
    internal func callServiceTicket(_ service: Servicio, _ body: RedencionTicketRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let ticketService = try JSONDecoder().decode(RedencionTicketResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.redencionTicket(ticketService), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.redencionTicket(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.redencionTicket(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.redencionTicket(nil), error)
        }
    }
    
    internal func callServiceLogOut(_ service: Servicio, _ body: LogOutRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaultResponse.self, from: data)
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
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.cerrarSesion(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.cerrarSesion(nil), error)
        }
    }
    
    internal func callServiceReplaceSim(_ service: Servicio, _ body: ReplaceSimRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(ReplaceSimResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudReemplazoSim(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudReemplazoSim(nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.solicitudReemplazoSim(nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.solicitudReemplazoSim(nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.solicitudReemplazoSim(nil), error)
        }
    }
    
    internal func callServiceSendOtpReplaceSim(_ service: Servicio, _ body: SendSimOtpRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(ReplaceSimResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.enviarOtpReemplazoSim(body: success, headers: result.headers), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
        }
    }
    
    internal func callServiceValidateOtpReplaceSim(_ service: Servicio, _ body: ValidateSimOtpRequest, uuidHeader: String, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            var contentService = service
            contentService.headers?.append(Headers(name: Cons.uuidHeader, value: uuidHeader))
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(ReplaceSimResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarOtpReemplazoSim(success), nil)
                    }catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.validarOtpReemplazoSim(nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.validarOtpReemplazoSim(nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.validarOtpReemplazoSim(nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.validarOtpReemplazoSim(nil), error)
        }
    }
    
    internal func callServiceCodeAreaList(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let areaCodes = try JSONDecoder().decode(AreaCodeResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.listaCodigoArea(areaCodes), nil)
                } catch {
                    let error = ErrorResponse()
                    error.statusCode = Cons.error2
                    error.responseCode = Cons.error2
                    error.errorMessage = CustomError.noData.errorDescription
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.listaCodigoArea(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                callback(.listaCodigoArea(nil), error)
            }
        }
    }
    
    internal func callServiceSendOtpNir(_ service: Servicio, _ body: OTPRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.enviarOtpNir(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.enviarOtpNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.enviarOtpNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.enviarOtpNir(nil), error)
        }
    }
    
    internal func callServiceValidateOTPNir(_ service: Servicio, _ body: ValidateOtpRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(OTPResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarOtpNir(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.validarOtpNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.validarOtpNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.validarOtpNir(nil), error)
        }
    }
    
    internal func callServiceUpdateNir(_ service: Servicio, _ body: UpdateNirRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let success = try JSONDecoder().decode(UpdateNirResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cambiarNir(success), nil)
                    } catch {
                        let error = ErrorResponse()
                        error.statusCode = Cons.error2
                        error.responseCode = Cons.error2
                        error.errorMessage = CustomError.noData.errorDescription
                        self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                        callback(.cambiarNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                    callback(.cambiarNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse()
            error.statusCode = Cons.error2
            error.responseCode = Cons.error2
            error.errorMessage = CustomError.noBody.errorDescription
            self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
            callback(.cambiarNir(nil), error)
        }
    }
}
