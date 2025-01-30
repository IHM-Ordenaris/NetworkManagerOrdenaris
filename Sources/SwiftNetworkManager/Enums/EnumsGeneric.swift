//
//  EnumsGeneric.swift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 10/06/24.
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
    /// Entorno de QA
    case qa
    /// Entorno de producción
    case pr
}

/// Lista de propiedades para seleccionar en la validación del número Bait
///   - login: Acción de validar en iniciar sesión
///   - signup: Acción de validar en registrar cuenta
///   - recharge: Acción de validar en recargar
///   - portability: Acción de validar en portabilidad`
///   - reset:Acción de validar en reestablecer contraseña
///   - nir: Acción de validar en cambiar código de área
public enum ActionBait: String {
    /// Iniciar sesión
    case login = "bait_login"
    /// Registrar cuenta
    case signup = "bait_registro"
    /// Recargas
    case recharge = "bait_recarga"
    /// Portabilidad
    case portability = "bait_portabilidad"
    /// Cambiar contraseña
    case reset = "bait_recuperacion"
    /// Cambiar código de área
    case nir = "bait_nir"
}

/// Lista de propiedades con los motivos para solicitar un reemplazo de SIM
///   - portability: Reemplazar SIM por portabilidad
///   - lostOrStolen:  Reemplazar SIM por robo o extravío
public enum RemplaceSimBait: Int {
    /// Cambio por portabilidad
    case portability = 1
    /// Cambio por robo o extravío
    case lostOrStolen = 2
}

/// Clases con propiedades y funciones para obtener la urls de consultar
internal class ProductService {
    enum ApiURL {
        /// Obtener por entorno
        case bait(environment: Environment)
        /// Ruta de BD local
        case db
        /// Url de iTunes
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
        /// Info de CDN
        case CDN(environment: Environment)
        /// Archivo local
        case file(_ name: String)
        /// Info de AppStore
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
///   - noConnection: Error de conexión
///   - noData: Error de datos
///   - noFile: Error de no existe el archivo local
///   - noUrl: Error de no existe le URL
///   - noBody: Error de parametros de envío incorrectos
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

/// Opciones para solicitar la OTP
///   - otpRegister: OTP tipo registrar cuenta
///   - otpPassword: OTP tipo cambiar contraseña
///   - otpRequestNir: OTP tipo cambiar SIM / Código de área
///   - otpValidate: Validar OTP
public enum OTPService: String {
    /// Registrar cuenta
    case otpRegister = "pin_webv2"
    /// Cambiar contraseña
    case otpPassword = "recuperacionv2"
    /// Cambiar SIM / Código de área
    case otpRequestNir = "generar_pin"
    /// Validar OTP
    case otpValidate = "validar_pin"
}
