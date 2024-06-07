//
//  NetworkModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - :::: Objetos REQUEST ::::
final class Servicio: Codable {
    var nombre: String
    var headers: [Headers]?
    var url: String
    var printResponse: Bool
    
    required init(nombre: String, headers: [Headers] = [Headers(nombre: "", valor: "")], url: String) {
        self.nombre = nombre
        self.headers = headers
        self.url = url
        self.printResponse = false
    }
}

final class Headers: Codable {
    var nombre: String
    var valor: String
    
    required init( nombre: String, valor: String ) {
        self.nombre = nombre
        self.valor = valor
    }
}

// MARK: - :::: Objetos response SUCCESS ::::
typealias CallbackCustomResponse = (_ response: CustomResponseObject?, _ failure: ErrorResponse?) -> ()

struct CustomResponseObject {
    var success: Bool = false
    var data: Data?
    var responseStr: String?
}

// MARK: - :::: Objetos response ERROR ::::
/// Error que responde el callback de todos los servicios hacia el Model
public class ErrorResponse: Codable, Error {
    public var statusCode: Int
    public var responseCode: Int
    public var errorMessage: String
    
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
