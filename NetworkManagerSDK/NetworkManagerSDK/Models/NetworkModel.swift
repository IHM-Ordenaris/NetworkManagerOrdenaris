//
//  NetworkModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - :::: Objetos REQUEST ::::
public typealias CallbackResponseLoadSetting = (_ response: Bool?, _ error: ErrorResponse?) -> ()
public struct MainServicio: Codable{
    let nombre: String
    let servicios: [Servicio]
}

public struct Servicio: Codable {
    let nombre: String
    let headers: Bool?
    let method: String?
    let auto: Bool?
    let valores: [Headers]?
    let url: String?
}

public struct Headers: Codable {
    let nombre: String
    let valor: String
}

public struct General {
    let structura: Codable
    let type: Any
}

// MARK: - :::: Objetos response SUCCESS ::::
typealias CallbackCustomResponse = (_ response: CustomResponseObject?, _ failure: ErrorResponse?) -> ()
/// Función obtener status token device
internal struct CustomResponseObject {
    var success: Bool = false
    var data: Data?
    var responseStr: String?
}

// MARK: - :::: Objetos response ERROR ::::
/// Error que responde el callback de todos los servicios hacia el Model
public class ErrorResponse: Codable, Error {
    public var statusCode: Int?
    public var responseCode: Int?
    public var errorMessage: String?
    
    enum CodingKeys: Int, CodingKey {
        case statusCode
        case responseCode
        case errorMessage
    }
    
    init() {
        statusCode = 0
        responseCode = 0
        errorMessage = ""
    }
}

/// Error general de algunos servicios
public class ErrorGeneralResponse: Codable {
    public var success: Bool
    public var errors: [String]?
    public var messages: [String]?
    public var responseCode: Int?
    public var message: String
    
    init() {
        success = false
        errors = []
        messages = []
        responseCode = 0
        message = ""
    }
}

/// Objeto de error para Request tryLogin
public class ErrorTryLoginResponse: Codable {
    public var message: String
    
    enum CodingKeys: Int, CodingKey {
        case message
    }
    
    init() {
        message = ""
    }
}
