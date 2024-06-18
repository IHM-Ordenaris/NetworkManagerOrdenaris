//
//  EnumsPath.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 10/06/24.
//

import Foundation

/// Lista de servicios a consultar
public enum ServiceName {
    case pagoSeguro
    case widget
    case captchaIos
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
    case registrarCuenta(params: ResetPasswordRequest)
    
    var getKey: String {
        switch self {
        case .pagoSeguro: return "pagoSeguro"
        case .widget: return "widget"
        case .captchaIos: return "captchaIos"
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
        case .registrarCuenta(let params): return "registrarCuenta"
        }
    }
}

public enum ServiceClass {
    case pagoSeguro(PagoSeguroResponse?)
    case widget(WidgetServiceResponse?)
    case captchaIos(CaptchaResponse?)
    case perfilGaleria([Headers]?)
    case perfilCamara([Headers]?)
    case escaneo([Headers]?)
    case version([Headers]?)
    case listaRecurrentes(RecurrenciasActivasResponse?)
    case cancelarRecurrente(DefaulResponse?)
    case suscripcionPush(Bool)
    case desuscripcionPush(Bool)
    case ofertasInternacionales(RecargaInternacionalResponse?)
    case eliminacion(DefaulResponse?)
    case datosUsuario(UsuarioResponse?)
}
