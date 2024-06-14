//
//  EnumsGeneric.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation
// Enumeraciòn para estatus de servicio
public enum StatusService: Int {
    case start = 1
    case finish = 2
}

// Enumeraciòn para estatus de servicio
public enum ResponseService {
    case request
    case success
    case error
}

/// Lista de propiedades para seleccionar el entorno a consultar
public enum Environment {
    case qa
    case pr
}

/// Clases con propiedades y funciones para obtener la urls de consultar
internal class ProductService {
    enum ApiURL {
        case bait(environment: Environment)
        case db
        
        var baseURL: String {
            switch self {
            case .bait(let env):
                switch env{
                case .pr: return "https://mibait.com"
                case .qa: return "https://baitqa.ordenaris.com"
                }
            case .db: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString ?? ""
            }
        }
    }
    
    enum Endpoint {
        case CDN(environment: Environment)
        case file(_ name: String)

        var path: String {
            switch self {
            case .CDN:
                return "/api/core/servicio/resources/app/cdn2"
            case .file(let name): return "\(name.lowercased()).plist"
            }
        }

        var url: String {
            switch self {
            case .CDN(let env): return "\(ApiURL.bait(environment: env).baseURL)\(path)"
            case .file: return "\(ApiURL.db.baseURL)\(path)"
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
