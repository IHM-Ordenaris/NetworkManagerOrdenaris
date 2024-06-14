//
//  EnumsPath.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 10/06/24.
//

import Foundation

/// Lista de servicios a consultar
public enum ServiceName {
    case version
    case widget
    case suscripcionPush(token: String, identificador: String?)
    
    var getKey: String {
        switch self {
        case .version: return "version"
        case .widget: return "widget"
        case .suscripcionPush: return "suscripcionPush"
        }
    }
}


public enum ServiceClass {
    case version([Headers]?)
    case widget(WidgetService?)
    case suscripcionPush(Bool)
}
