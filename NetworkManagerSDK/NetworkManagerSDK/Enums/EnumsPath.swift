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
    case captchaIos(version: String)
    
    var getKey: String {
        switch self {
        case .version: return "version"
        case .widget: return "widget"
        case .captchaIos: return "captchaIos"
        }
    }
}


public enum ServiceClass {
    case version([Headers]?)
    case widget(WidgetService?)
}
