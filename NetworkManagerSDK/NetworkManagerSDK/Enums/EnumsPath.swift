//
//  EnumsPath.swift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 10/06/24.
//

import Foundation

/// Lista de servicios a consultar
public enum ServiceName {
    case pagoSeguro
    case widget
    case validarBait(numero: String, accion: ActionBait)
    case perfilGaleria
    case perfilCamara
    case escaneo
    case version(params: InfoAppStoreRequest)
    case listaRecurrentes(params: RecurrenciasActivasRequest)
    case cancelarRecurrente(params: RecurrenciasActivasRequest, uuid: String)
    case suscripcionPush(params: InformacionClientePush)
    case desuscripcionPush(params: InformacionClientePush)
    case ofertasInternacionales
    case eliminacion(params: EliminacionRequest)
    case acceso(params: AccesoRequest)
    case cambiarPerfil(params: PerfilRequest)
    case cambiarPass(params: PasswordRequest)
    case reestablecerPassword(params: ResetPasswordRequest)
    case registrarCuenta(params: CompletarRegistro)
    case solicitudOtp(params: OTPRequest)
    case verificarOtp(params: ValidateOtpRequest)
    case consumo(params: MobileHotspotRequest)
    case newConsumo(replaceParams: Dictionary<String, String>)
    case ofertas
    case ofertasSams
    case asociados
    case validarImei(params: ImeiRequest)
    case solicitudPortabilidad(params: PortabilidadElementsRequest)
    case redencionTicket(params: RedencionTicketRequest)
    case cerrarSesion(params: LogOutRequest)
    case solicitudReemplazoSim(params: ReplaceSimRequest)
    case enviarOtpReemplazoSim(params: SendSimOtpRequest)
    case validarOtpReemplazoSim(params: ValidateSimOtpRequest, uuidOtp: String)
    case listaCodigoArea
    case enviarOtpNir(params: OTPRequest)
    case validarOtpNir(params: ValidateOtpRequest)
    case cambiarNir(params: UpdateNirRequest)
    
    var getKey: String {
        switch self {
        case .pagoSeguro: return "securePayment"
        case .widget: return "widget"
        case .validarBait: return "validateProfile"
        case .perfilGaleria: return "permissionGallery"
        case .perfilCamara: return "permissionCamera"
        case .escaneo: return "permissionCamera"
        case .version: return "version-ios"
        case .listaRecurrentes: return "listRecurrences"
        case .cancelarRecurrente: return "cancelRecurrence"
        case .suscripcionPush: return "pushSubscription"
        case .desuscripcionPush: return "pushUnsuscribe"
        case .ofertasInternacionales: return "internationalOffers"
        case .eliminacion: return "deleteAccount"
        case .acceso: return "login"
        case .cambiarPerfil: return "updateAccount"
        case .cambiarPass: return "updateAccount"
        case .reestablecerPassword: return "recoveryPassword"
        case .registrarCuenta: return "signup"
        case .solicitudOtp: return "requestPIN"
        case .verificarOtp: return "verifyPIN"
        case .consumo: return "consumption"
        case .newConsumo: return "informationSubscriber"
        case .ofertas: return "offers"
        case .ofertasSams: return "packagesOffers"
        case .asociados: return "partnerOffers"
        case .validarImei: return "imeiValidations"
        case .solicitudPortabilidad: return "portability"
        case .redencionTicket: return "redeemTicket"
        case .cerrarSesion: return "logout"
        case .solicitudReemplazoSim: return "registerRequest"
        case .enviarOtpReemplazoSim: return "sendOTP_reeplace"
        case .validarOtpReemplazoSim: return "validateOTP_reeplace"
        case .listaCodigoArea: return "listCodes"
        case .enviarOtpNir: return "sendOTP_NIR"
        case .validarOtpNir: return "validateOTP_NIR"
        case .cambiarNir: return "updateNIR"
        }
    }
}

public enum ServiceClass {
    case pagoSeguro(PagoSeguroResponse?)
    case widget(WidgetServiceResponse?)
    case validarBait(ValidateBaitResponse?)
    case perfilGaleria([Headers]?)
    case perfilCamara([Headers]?)
    case escaneo([Headers]?)
    case version(InfoAppBait?)
    case listaRecurrentes(RecurrenciasActivasResponse?)
    case cancelarRecurrente(DefaultResponse?)
    case suscripcionPush(Bool)
    case desuscripcionPush(Bool)
    case ofertasInternacionales(RecargaInternacionalResponse?)
    case eliminacion(DefaultResponse?)
    case datosUsuario(UsuarioResponse?)
    case solicitudOtp(DefaultResponse?)
    case verificarOtp(OTPResponse?)
    case consumo(MobileHotspotResponse?)
    case newConsumo(ConsumptionResponse?)
    case ofertas(OffersResponse?)
    case validarImei(ImeiResponse?)
    case solicitudPortabilidad(PortabilityResponse?)
    case redencionTicket(RedencionTicketResponse?)
    case cerrarSesion(DefaultResponse?)
    case solicitudReemplazoSim(ReplaceSimResponse?)
    case enviarOtpReemplazoSim(body: ReplaceSimResponse?, headers: [AnyHashable: Any]?)
    case validarOtpReemplazoSim(ReplaceSimResponse?)
    case listaCodigoArea(AreaCodeResponse?)
    case enviarOtpNir(DefaultResponse?)
    case validarOtpNir(OTPResponse?)
    case cambiarNir(UpdateNirResponse?)
}
