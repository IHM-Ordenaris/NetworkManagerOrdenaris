//
//  NetworkModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - :::: Objetos REQUEST ::::
public typealias CallbackResponseLoadSetting = @Sendable (_ response: Bool?, _ error: ErrorResponse?) -> ()
public struct MainServicio: Codable, @unchecked Sendable {
    let name: String
    let services: [Servicio]
}

public struct Servicio: Codable, @unchecked Sendable {
    internal let name: String
    internal let method: String?
    public var headers: [Headers]?
    internal var url: String?
}

public struct Headers: Codable {
    public let name: String
    public let value: String
}

// MARK: - :::: Objetos response SUCCESS ::::
typealias CallbackCustomResponse = @Sendable (_ response: CustomResponseObject?, _ failure: ErrorResponse?) -> ()
/// Función obtener status token device
internal struct CustomResponseObject {
    var success: Bool = false
    var data: Data?
    var responseStr: String?
    var headers: [AnyHashable : Any]?
}

// MARK: - :::: Objetos response ERROR ::::
/// Error que responde el callback de todos los servicios hacia el Model
public struct ErrorResponse: Error {
    public let statusCode: Int?
    public let responseCode: Int?
    public let errorMessage: String?
}
