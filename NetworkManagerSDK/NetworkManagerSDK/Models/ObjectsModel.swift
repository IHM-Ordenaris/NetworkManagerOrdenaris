//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

public typealias CallbackResponseTarget = (_ response: ServiceClass?, _ error: ErrorResponse?) -> ()
// MARK: - ⚠️ typealias & Objects GET ::::::::::::::::
//TODO: Modelo del servicio Widget
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

//TODO: Modelo del servicio Recarga Internacional
///Atributos de response
public struct RecargaInternacionalResponse: Decodable {
    public let ofertas: [Oferta]?
    public let busqueda: [BusquedaInternacional]?
}

public struct Oferta: Decodable {
    public let disfruta: String?
    public let duracion: String?
    public let registro: String?
    public let estado: Int?
    public let imagen: String?
    public let incluye: String?
    public let nombre: String?
    public let offeringid: String?
    public let pesos: Float?
    public let tipo: Int?
    public let vigencia: String?
}

public struct BusquedaInternacional: Decodable {
    public let origen: String?
    public let destinos: [DestinosInternacionales]?
}

public struct DestinosInternacionales: Decodable {
    public let nombre: String?
    public let oferta: String?
}

// MARK: - ⚠️ typealias & Objects POST ::::::::::::::::
//TODO: Modelo del servicio Pago Seguro
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

//TODO: Modelo del servicio de Captcha
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

//TODO: Modelo del servicio de Lista y Cancelar Recurrencias
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

public struct DefaulResponse: Decodable {
    public let code: Int?
    public let success: Bool?
    public let mensaje: String?
    public let fechaDesbloqueo: String?
}

//TODO: Modelo del servicio de Subscribir y Cancelar Recurrencias
///Atributos de request
public struct SubscripcionPushRequest: Encodable {
    internal let app: App = App(nombre: "Bait")
    public let informacion: InformacionClientePush
}

internal struct App: Encodable {
     let nombre: String
}

public struct InformacionClientePush: Encodable {
    public let token: String
    public let plataforma: Int = 3
    public let identificador: String?
    public let grupos: [String] = ["ios"]
    public let listaTemas: [Temas]?
    
    public init(token: String, identificador: String?, listaTemas: [Temas]?) {
        self.token = token
        self.identificador = identificador
        self.listaTemas = listaTemas
    }
}

public struct Temas: Encodable {
    public let nombre: String?
    public let identificador: String?
    public let fechaExpiracion: String?
}

// MARK: - ⚠️ typealias & Objects PUT ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
