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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        callback(.pagoSeguro(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.pagoSeguro(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.widget(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarBait(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.validarBait(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(.validarBait(nil), error)
        }
    }
    
    internal func callServiceInfoAppStore(_ service: Servicio, _ body: InfoAppStoreRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let serviceAppStore =  Servicio(name: "iTunes", method: HTTPMethod.get.rawValue, headers: nil, url: ProductService.Endpoint.appStore.url)
        var bodyData: Dictionary<String, String> = ["bundleId": body.bundleId]
        if let country = body.country {
            bodyData["country"] = country
        }
        Network.callNetworking(servicio: serviceAppStore, params: bodyData, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let appStore = try JSONDecoder().decode(InfoAppStoreResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    let mandatory = service.headers?.first(where: {
                        $0.name == "mandatory"
                    })
                    callback(.version(InfoAppBait(version: appStore.results.first?.version, mandatory: NSString(string: mandatory?.value ?? "false").boolValue)), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.version(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.version(nil), error)
            }
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.listaRecurrentes(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.listaRecurrentes(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cancelarRecurrente(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.cancelarRecurrente(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.suscripcionPush(false), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.suscripcionPush(false), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.desuscripcionPush(false), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.desuscripcionPush(false), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertasInternacionales(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.eliminacion(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.eliminacion(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.datosUsuario(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.datosUsuario(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(.datosUsuario(nil), error)
        }
    }
    
    internal func callServiceUserInfo(_ service: Servicio, _ body: UserInfoRequest, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        do {
            let encoder = JSONEncoder()
            let bodyData = try encoder.encode(body)
            Network.callNetworking(servicio: service, params: bodyData, printResponse) { response, failure in
                if let result = response, let data = result.data, result.success {
                    do {
                        let userData = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.informacionUsuario(userData), nil)
                    } catch {
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.informacionUsuario(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.informacionUsuario(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(.informacionUsuario(nil), error)
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudOtp(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.solicitudOtp(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.verificarOtp(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.verificarOtp(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.consumo(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.consumo(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(.consumo(nil), error)
        }
    }
    
    internal func callServiceConsumption(_ service: inout Servicio, _ replaceParams: Dictionary<String, String>, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        
        service.url = service.url?.replacingOccurrences(of: "#type#", with: replaceParams["type"]!)
        service.url = service.url?.replacingOccurrences(of: "#identifier#", with: replaceParams["identifier"]!)
        service.url = service.url?.replacingOccurrences(of: "#view#", with: replaceParams["view"]!)
        
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let success = try JSONDecoder().decode(ConsumptionResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.newConsumo(success), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.newConsumo(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.newConsumo(nil), error)
            }
        }
    }
    
    internal func callServiceOffer(key: ServiceName, forceUpdate: Bool, _ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        let manager = VersionManager()
        if let urlString = service.url, let url = URL(string: urlString), let v = url.valueOf("v") {
            Task {
                await manager.setVersion(v)
            }
        }
        
        if forceUpdate  {
            UserDefaults.standard.removeObject(forKey: key.getKey)
        }
        
        Task {
            let version = await manager.version
            if let versionDefaults = UserDefaults.standard.string(forKey: key.getKey), version == versionDefaults {
                callback(.ofertas(OffersResponse(success: true, lista: nil)), nil)
            } else {
                Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
                    if let result = response, let data = result.data, result.success {
                        do {
                            let offerResponse = try JSONDecoder().decode(OffersResponse.self, from: data)
                            self.callbackServices?(ServicesPlugInResponse(.finish))
                            if let v = version, !offerResponse.lista!.isEmpty {
                                UserDefaults.standard.set(v, forKey: key.getKey)
                            }
                            callback(.ofertas(offerResponse), nil)
                        } catch {
                            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                            self.callbackServices?(ServicesPlugInResponse(.finish))
                            callback(.ofertas(nil), error)
                        }
                    } else if let error = failure {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.ofertas(nil), error)
                    }
                }
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarImei(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.validarImei(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudPortabilidad(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.solicitudPortabilidad(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.redencionTicket(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.redencionTicket(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cerrarSesion(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.cerrarSesion(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudReemplazoSim(nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.solicitudReemplazoSim(nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.solicitudReemplazoSim(nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.enviarOtpReemplazoSim(body: nil, headers: nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarOtpReemplazoSim(nil), error)
                    }
                } else if let error = failure {
                    if let statusCode = error.statusCode, 400...499 ~= statusCode {
                        callback(.validarOtpReemplazoSim(nil), error)
                    } else {
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarOtpReemplazoSim(nil), error)
                    }
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.listaCodigoArea(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.enviarOtpNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.enviarOtpNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.validarOtpNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.validarOtpNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
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
                        let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                        self.callbackServices?(ServicesPlugInResponse(.finish))
                        callback(.cambiarNir(nil), error)
                    }
                } else if let error = failure {
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.cambiarNir(nil), error)
                }
            }
        } catch {
            let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noBody.errorDescription)
            self.callbackServices?(ServicesPlugInResponse(.finish))
            callback(.cambiarNir(nil), error)
        }
    }
    
    internal func callServiceAdvertising(_ service: inout Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        service.url = service.url?.replacingOccurrences(of: "#os#", with: Cons.iOS)
        Network.callNetworking(servicio: service, params: nil, printResponse, timeOut: 3) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let areaCodes = try JSONDecoder().decode(AdvertisingResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.advertising(areaCodes), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.advertising(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.advertising(nil), error)
            }
        }
    }
    
    internal func callServiceOffersSim(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let areaCodes = try JSONDecoder().decode(OffersSimResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertaSim(areaCodes), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertaSim(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.ofertaSim(nil), error)
            }
        }
    }
    
    internal func callServiceOfferseSim(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let areaCodes = try JSONDecoder().decode(OfferseSimResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertaeSim(areaCodes), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.ofertaeSim(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.ofertaeSim(nil), error)
            }
        }
    }
    
    internal func callServiceAvataresList(_ service: Servicio, _ printResponse: Bool, _ callback: @escaping CallbackResponseTarget) {
        Network.callNetworking(servicio: service, params: nil, printResponse) { response, failure in
            if let result = response, let data = result.data, result.success {
                do {
                    let avataresService = try JSONDecoder().decode(AvatarServiceResponse.self, from: data)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.avatares(avataresService), nil)
                } catch {
                    let error = ErrorResponse(statusCode: Cons.error2, responseCode: Cons.error2, errorMessage: CustomError.noData.errorDescription)
                    self.callbackServices?(ServicesPlugInResponse(.finish))
                    callback(.avatares(nil), error)
                }
            } else if let error = failure {
                self.callbackServices?(ServicesPlugInResponse(.finish))
                callback(.avatares(nil), error)
            }
        }
    }
}

actor VersionManager {
    var version: String?

    func setVersion(_ version: String) {
        self.version = version
    }

    func getVersion() -> String? {
        return self.version
    }
}
