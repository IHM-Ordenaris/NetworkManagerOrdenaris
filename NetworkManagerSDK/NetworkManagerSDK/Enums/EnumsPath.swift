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
    case version
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
    case ofertas
    case ofertasSams
    case asociados
    case validarImei(params: ImeiRequest)
    case solicitudPortabilidad(params: PortabilidadElementsRequest)
    case redencionTicket(params: RedencionTicketRequest)
    case cerrarSesion(params: LogOutRequest)
    
    var getKey: String {
        switch self {
        case .pagoSeguro: return "pagoSeguro"
        case .widget: return "widget"
        case .validarBait: return "captchaIos"
        case .perfilGaleria: return "perfilGaleria"
        case .perfilCamara: return "perfilCamara"
        case .escaneo: return "escaneo"
        case .version: return "version"
        case .listaRecurrentes: return "listaRecurrentes"
        case .cancelarRecurrente: return "cancelarRecurrente"
        case .suscripcionPush: return "suscripcionPush"
        case .desuscripcionPush: return "desuscripcionPush"
        case .ofertasInternacionales: return "ofertasInternacionales"
        case .eliminacion: return "eliminacion"
        case .acceso: return "acceso"
        case .cambiarPerfil: return "cambiarPerfil"
        case .cambiarPass: return "cambiarPerfil"
        case .reestablecerPassword: return "reestablecerPassword"
        case .registrarCuenta: return "registrarCuenta"
        case .solicitudOtp: return "solicitudPIN"
        case .verificarOtp: return "verificarPIN"
        case .consumo: return "consumo3"
        case .ofertas: return "ofertas"
        case .ofertasSams: return "ofertasSams"
        case .asociados: return "ofertas-asociados"
        case .validarImei: return "validacion-imei"
        case .solicitudPortabilidad: return "solicitudPortabilidad"
        case .redencionTicket: return "redencionTicket"
        case .cerrarSesion: return "cerrarSesion"
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
    case version(Servicio?)
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
    case ofertas(OffersResponse?)
    case validarImei(ImeiResponse?)
    case solicitudPortabilidad(PortabilityResponse?)
    case redencionTicket(RedencionTicketResponse?)
    case cerrarSesion(DefaultResponse?)
}
