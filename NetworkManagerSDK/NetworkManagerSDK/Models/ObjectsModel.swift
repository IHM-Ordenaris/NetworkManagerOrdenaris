//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

public typealias CallbackResponseTarget = (_ response: ServiceClass?, _ error: ErrorResponse?) -> ()
// MARK: - ⚠️ typealias & Objects GET ::::::::::::::::
//TODO: Modelo del servicio de respuesta Widget
///Atributos de response
public struct WidgetServiceResponse: Decodable {
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
//TODO: Modelo del servicio de requerimiento Pago Seguro
///Atributos de request
internal struct PagoSeguroRequest: Encodable {
    let uuid: String
}

///Atributos de response
public struct PagoSeguroResponse: Decodable {
    public let success: Bool?
    public let ordCliente: String?
    public let llavero: String?
}

//TODO: Modelo del servicio de requerimiento Captcha
///Atributos de response
public struct CaptchaResponse: Decodable {
    public let success: Bool?
    public let informacion: Captcha?
}

public struct Captcha: Decodable {
    public let url: String?
    public let publico: String?
    public let form: String?
    public let activo: Bool?
    //public let token: String?
    //public let servicio: String?
    //public let accion: String?
}

//TODO: Modelo del servicio de requerimiento Recurrencias
///Atributos de request
internal struct RecurrenciasActivasRequest: Encodable {
    let identificador: String
}

///Atributos de response
public struct RecurrenciasActivasResponse: Decodable {
    public let lista: [RecurrenciaObj]?
    public let success: Bool?
}

public struct RecurrenciaObj: Decodable {
    public let creacion: String?
    public let fechaCargo: String?
    public let fechaProxima: String?
    public let costo: Double?
    public let uuid: String?
    public let referencia1: String?
    public let referencia2: String?
    public let referencia3: String?
    public let referencia4: String?
    public let referencia5: String?
}


internal struct SubscripcionPushRequest: Encodable {
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
