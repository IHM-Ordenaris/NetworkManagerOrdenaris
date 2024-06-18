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
public struct RecurrenciasActivasRequest: Encodable {
    internal let identificador: String
    
    public init(identificador: String) {
        self.identificador = identificador
    }
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
    internal let token: String
    internal let plataforma: Int = 3
    internal let identificador: String?
    internal let grupos: [String] = ["ios"]
    internal let listaTemas: [Temas]?
    
    public init(token: String, identificador: String?, listaTemas: [Temas]?) {
        self.token = token
        self.identificador = identificador
        self.listaTemas = listaTemas
    }
}

public struct Temas: Encodable {
    internal let nombre: String?
    internal let identificador: String?
    internal let fechaExpiracion: String?
}

//TODO: Modelo del servicio de eliminación
///Atributos de request
public struct EliminacionRequest: Encodable {
    internal let access: String
    internal let pass: String
    
    public init(access: String, pass: String) {
        self.access = access
        self.pass = pass
    }
}

//TODO: Modelo del servicio de LogIn
///Atributos de request
public struct AccesoRequest: Encodable {
    internal let operacion: String = "login"
    internal let numero: String
    internal let pass: String
    
    public init(numero: String, pass: String) {
        self.numero = numero
        self.pass = pass
    }
}

///Atributos de response
public struct UsuarioResponse: Decodable {
    public let access: String?
    public let numero: String?
    public let foto: String?
    public let success: Bool?
    public let permiso: Int?
    public let nombre: String?
    public let email: String?
    public let mensaje: String?
    public let ssoLogin: Bool?
    public let isBait: Bool?
    public let isSsoInvite: Bool?
}

//TODO: Modelo del servicio de Update Perfil
///Atributos de request
public struct PerfilRequest: Encodable {
    internal let access: String
    internal let operacion: String = "actualizacionv2"
    internal let nombre: String
    internal let email: String
    internal let permiso: Int
    internal let foto: String
    
    public init(access: String, nombre: String, email: String, permiso: Int, foto: String) {
        self.access = access
        self.nombre = nombre
        self.email = email
        self.permiso = permiso
        self.foto = foto
    }
}

public struct PasswordRequest: Encodable {
    internal let access: String
    internal let operacion: String = "actualizacionv2"
    internal let actual_pass: String?
    internal let nueva_pass: String?
    
    public init(access: String, actual_pass: String, nueva_pass: String) {
        self.access = access
        self.actual_pass = actual_pass
        self.nueva_pass = nueva_pass
    }
}

//TODO: Modelo del servicio de Recuperar Password
///Atributos de request
public struct ResetPasswordRequest: Encodable {
    internal let operacion: String = "restablecer_passv2"
    internal let pass: String
    internal let numero: String
    internal let uuid: String
    
    public init(numero: String, pass: String, uuid:String) {
        self.pass = pass
        self.numero = numero
        self.uuid = uuid
    }
}

//TODO: Modelo del servicio de Crear Cuenta
///Atributos de request
public struct CompletarRegistro: Encodable {
    internal let operacion: String = "registro_datos"
    internal let numero: String
    internal let nombre: String
    internal let email: String
    internal let permiso: Int
    internal let pass: String
    internal let foto: String
    internal let uuid: String
    
    public init(numero: String, nombre: String, email: String, permiso: Int, pass: String, foto: String, uuid: String) {
        self.numero = numero
        self.nombre = nombre
        self.email = email
        self.permiso = permiso
        self.pass = pass
        self.foto = foto
        self.uuid = uuid
    }
}

// MARK: - ⚠️ typealias & Objects PUT ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
