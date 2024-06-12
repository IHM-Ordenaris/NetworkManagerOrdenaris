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

public enum Environment {
    case qa
    case pr
}

internal class ProductService {
    private enum ApiURL {
        case bait(environment: Environment)
        case db
        
        internal var baseURL: String {
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

        private var path: String {
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

internal enum CustomError {
    case noConnection, noData, noFile, noUrl
}

extension CustomError{
    internal var errorDescription: String? {
        switch self {
        case .noData: return "No existe información"
        case .noConnection: return "No hay conexión a internet"
        case .noFile: return "No existe el archivo plist"
        case .noUrl: return "No existe la Url"
        }
    }
}
