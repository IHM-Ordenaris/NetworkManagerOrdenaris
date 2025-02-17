//
//  EnumsGeneric.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation
// Enumeración para estatus de servicio
public enum StatusService: Int {
    case start = 1
    case finish = 2
}

// Enumeración para estatus de servicio
public enum ResponseService {
    case request
    case success
    case error(Error)
}

/// Lista de propiedades para seleccionar el entorno a consultar
public enum Environment {
    case qa
    case pr
}

/// Lista de propiedades para seleccionar en la valicadación del número Bait
public enum ActionBait: String {
    case login = "bait_login"
    case signup = "bait_registro"
    case recharge = "bait_recarga"
    case portability = "bait_portabilidad"
    case reset = "bait_recuperacion"
    case nir = "bait_nir"
}

/// Lista de propiedades con los motivos para solicitar un reemplazo de SIM
public enum RemplaceSimBait: Int {
    case portability = 1
    case lostOrStolen = 2
}

/// Clases con propiedades y funciones para obtener la urls de consultar
internal class ProductService {
    enum ApiURL {
        case bait(environment: Environment)
        case db
        case itunes
        
        var baseURL: String {
            switch self {
            case .bait(let env):
                switch env{
                case .pr: 
                    "https://mibait.com"
                case .qa: 
                    "https://baitqa.ordenaris.com"
                }
            case .db: 
                FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString ?? ""
            case .itunes: 
                "https://itunes.apple.com"
            }
        }
    }
    
    enum Endpoint {
        case CDN(environment: Environment)
        case file(_ name: String)
        case appStore

        var path: String {
            switch self {
            case .CDN:
                "/api/core/servicio/resources/app/v20/get-cdn"
            case .file(let name):
                "\(name.lowercased()).plist"
            case .appStore:
                "/lookup"
            }
        }

        var url: String {
            switch self {
            case .CDN(let env):
                "\(ApiURL.bait(environment: env).baseURL)\(path)"
            case .file:
                "\(ApiURL.db.baseURL)\(path)"
            case .appStore:
                "\(ApiURL.itunes.baseURL)\(path)"
            }
        }
    }
}

/// Catalogo de errores que puedes existir en la consulta de los servicios 
internal enum CustomError {
    case noConnection, noData, noFile, noUrl, noBody
}

extension CustomError {
    var errorDescription: String? {
        switch self {
        case .noData: return "No existe información"
        case .noConnection: return "No hay conexión a internet"
        case .noFile: return "No existe el archivo plist"
        case .noUrl: return "No existe la Url"
        case .noBody: return "Los datos a enviar son incorrectos"
        }
    }
}

public enum OTPService: String {
    case otpRegister = "pin_webv2"
    case otpPassword = "recuperacionv2"
    case otpRequestNir = "generar_pin"
    case otpValidate = "validar_pin"
}
