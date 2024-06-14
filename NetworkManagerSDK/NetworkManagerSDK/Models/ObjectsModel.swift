//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - ⚠️ typealias & Objects GET ::::::::::::::::
public typealias CallbackResponseTarget = (_ response: ServiceClass?, _ error: ErrorResponse?) -> ()
public struct WidgetService: Decodable {
    public let version: String?
    public let change_date: String?
    public let service_order: [String]?
    public let stores_order: [String]?
    public let stores: [StoreService]?
    public let services: [StoreService]?
}

public struct StoreService: Decodable {
    public let id: String?
    public let name: String?
    public let brand: String?
    public let brand_app: String?
    public let tagline: String?
    public let title: String?
    public let description: String?
    public let thumbnail: String?
    public let media: String?
    public let link: String?
    public let button: String?
}

// MARK: - ⚠️ typealias & Objects POST ::::::::::::::::

internal struct SubscripcionPush: Encodable {
    let app: App
    let informacion: InformacionClientePush
}

internal struct App: Encodable {
    let nombre: String
}

internal struct InformacionClientePush: Encodable {
    let token: String
    let plataforma: Int
    let identificador: String?
    let grupos: [String]
    let listaTemas: [Temas]?
}

internal struct Temas: Encodable {
    let nombre: String?
    let identificador: String?
    let fechaExpiracion: String?
}

// MARK: - ⚠️ typealias & Objects PUT ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
