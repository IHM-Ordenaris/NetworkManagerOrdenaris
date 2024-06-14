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
    case listaRecurrentes(phoneNumber: String)
    case cancelarRecurrente(phoneNumber: String, uuid: String)
    case suscripcionPush(token: String, phoneNumber: String?)
    case desuscripcionPush(client: InformacionClientePush)
    case ofertasInternacionales
    
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
}
