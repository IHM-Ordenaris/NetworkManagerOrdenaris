//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 10/06/24.
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
    public let pesos: Double?
    public let tipo: Int?
    public let vigencia: String?
}

public struct BusquedaInternacional: Decodable {
    public let origen: String?
    public let destinos: [DestinosInternacionales]?
}

public struct DestinosInternacionales: Decodable, Hashable {
    public let nombre: String?
    public let oferta: String?
}

//TODO: Modelo del servicio Ofertas
///Atributos de response
public struct OffersResponse: Decodable {
    public let success: Bool?
    public let lista: [Oferta]?
}

//TODO: Modelo del servicio Portabilidad
///Atributos de request
public struct ImeiRequest: Encodable {
    private let IMEI: String
    
    public init(imei: String) {
        self.IMEI = imei
    }
}

///Atributos de response
public struct ImeiResponse: Decodable {
    public let success: Bool?
    public let mensaje: String?
    public let data: ImeiData?
}

public struct ImeiData: Decodable {
    public let blocked: String?
    public let homologated: String?
    public let soportaESIM: String?
}

//TODO: Modelo del servicio Lista Códigos de Área
///Atributos de response
public struct AreaCodeResponse: Decodable {
    public let success: Bool?
    public let lista: [State]?
}

public struct State: Decodable {
    public let esatdo: String?
    public let municipios: [City]?
}

public struct City: Decodable {
    public let municipio: String?
    public let nirs: [AreaCode]?
}

public struct AreaCode: Decodable {
    public let numero: String?
}

//TODO: Modelo del servicio iTunes (appStore)
///Atributos de request
public struct InfoAppStoreRequest {
    internal let bundleId: String
    internal let country: String?
    
    public init(bundleId: String, country: String?) {
        self.bundleId = bundleId
        self.country = country
    }
}

///Atributos de response
internal struct InfoAppStoreResponse: Decodable {
    internal let results: [InfoResult]
}

internal struct InfoResult: Decodable {
    internal let version: String
}

public struct InfoAppBait {
    public let version: String
    public let mandatory: Bool
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

//TODO: Modelo del servicio de Lista y Cancelar Recurrencias
///Atributos de request
public struct RecurrenciasActivasRequest: Encodable {
    private let identificador: String
    
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

public struct DefaultResponse: Decodable {
    public let code: Int?
    public let success: Bool?
    public let mensaje: String?
    public let message: String?
    public let fechaDesbloqueo: String?
}

//TODO: Modelo del servicio de Subscribir y Cancelar Recurrencias
///Atributos de request
internal struct SubscripcionPushRequest: Encodable {
    private let app: App = App(nombre: "Bait")
    public let informacion: InformacionClientePush
}

internal struct App: Encodable {
     let nombre: String
}

public struct InformacionClientePush: Encodable {
    private let token: String
    private let plataforma: Int = 3
    private let identificador: String?
    private let grupos: [String] = ["ios"]
    private let listaTemas: [Temas]?
    
    public init(token: String, identificador: String?, listaTemas: [Temas]?) {
        self.token = token
        self.identificador = identificador
        self.listaTemas = listaTemas
    }
}

public struct Temas: Encodable {
    private let nombre: String?
    private let identificador: String?
    private let fechaExpiracion: String?
    
    public init(nombre: String?, identificador: String?, fechaExpiracion: String?) {
        self.nombre = nombre
        self.identificador = identificador
        self.fechaExpiracion = fechaExpiracion
    }
}

//TODO: Modelo del servicio de eliminación
///Atributos de request
public struct EliminacionRequest: Encodable {
    private let access: String
    private let pass: String
    
    public init(access: String, pass: String) {
        self.access = access
        self.pass = pass
    }
}

//TODO: Modelo del servicio de LogIn
///Atributos de request
public struct AccesoRequest: Encodable {
    private let operacion: String = "login"
    private let numero: String
    private let pass: String
    
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
    public let avatar: Int?
}

//TODO: Modelo del servicio de Update Perfil
///Atributos de request
public struct PerfilRequest: Encodable {
    private let access: String
    private let operacion: String = "actualizacionv2"
    private let nombre: String
    private let email: String
    private let permiso: Int
    private let foto: String = ""
    private let avatar: Int
    
    public init(access: String, nombre: String, email: String, permiso: Int, avatar: Int) {
        self.access = access
        self.nombre = nombre
        self.email = email
        self.permiso = permiso
        self.avatar = avatar
    }
}

public struct PasswordRequest: Encodable {
    private let access: String
    private let operacion: String = "actualizacionv2"
    private let actual_pass: String?
    private let nueva_pass: String?
    
    public init(access: String, actual_pass: String, nueva_pass: String) {
        self.access = access
        self.actual_pass = actual_pass
        self.nueva_pass = nueva_pass
    }
}

//TODO: Modelo del servicio de Recuperar Password
///Atributos de request
public struct ResetPasswordRequest: Encodable {
    private let operacion: String = "restablecer_passv2"
    private let pass: String
    private let numero: String
    private let uuid: String
    
    public init(numero: String, pass: String, uuid:String) {
        self.pass = pass
        self.numero = numero
        self.uuid = uuid
    }
}

//TODO: Modelo del servicio de Crear Cuenta
///Atributos de request
public struct CompletarRegistro: Encodable {
    private let operacion: String = "registro_datos"
    private let numero: String
    private let nombre: String
    private let email: String
    private let permiso: Int
    private let pass: String
    private let foto: String
    private let uuid: String
    
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

//TODO: Modelo del servicio de OTP
///Atributos de request
public struct OTPRequest: Encodable {
    private let operacion: String
    private let numero: String
    
    public init(numero: String, operacion: OTPService) {
        self.operacion = operacion.rawValue
        self.numero = numero
    }
}

///Atributos de request Validar OTP
public struct ValidateOtpRequest: Encodable {
    private let operacion: String = OTPService.otpValidate.rawValue
    private let numero: String
    private let pin: String
    
    public init(numero: String, pin: String) {
        self.numero = numero
        self.pin = pin
    }
}

///Atributos de response
public struct OTPResponse: Decodable{
    public let code: Int?
    public let success: Bool?
    public let mensaje: String?
    public let uuid: String?
    public let redireccion: Bool?
}

//TODO: Modelo del servicio de Consumo
///Atributos de request
public struct MobileHotspotRequest: Encodable {
    private let access: String
    
    public init(access: String) {
        self.access = access
    }
}

///Atributos de response
public struct MobileHotspotResponse: Decodable {
    public let consumo: [MobileHotspotData]?
    public let success: Bool?
    public let proxima_recarga: String?
    public let offeringsIds: [MobileHotspotOffers]?
    public let comparteDatos: Bool?
    public let esIlimitado: Bool?
    public let fechaConsumo: Date?
}

public struct MobileHotspotData: Decodable {
    public let mb_usados: Float?
    public let mb_totales: Float?
    public let mb_disponibles: Float?
    public let min_disponibles: Float?
    public let min_usados: Float?
    public let sms_disponibles: Float?
    public let sms_usados: Float?
    public let nombre: String?
    public let tipo: Int?
}

public struct MobileHotspotOffers: Decodable {
    public let expireDate: String?
    public let offeringId: String?
}

//TODO: Modelo del servicio de Nuevo Consumo
///Atributos de response
public struct ConsumptionResponse: Decodable {
    public let success: Bool?
    public let data: [ConsuptionData]?
}

public struct ConsuptionData: Decodable {
    public let category: String?
    public let type: String?
    public let tethering: Bool?
    public let unlimited: Bool?
    public let resume: ConsuptionResume?
    public let offers_detail: [ConsuptionOffersDetail]?
}

public struct ConsuptionResume: Decodable {
    public let total: Double?
    public let unused: Double?
    public let expire_date: String?
}

public struct ConsuptionOffersDetail: Decodable {
    public let offering_id: String?
    public let total: Double?
    public let unused: Double?
    public let effective_date: String?
    public let expire_date: String?
    public let is_package: Bool?
}

//TODO: Modelo del servicio de Portabilidad
///Atributos de request
internal struct PortabilidadRequest: Encodable {
    let portabilidad: PortabilidadElementsRequest
}

public struct PortabilidadElementsRequest: Encodable {
    private let compania: String
    private let numeroActual: String
    private let imei: String
    private let nip: String
    private let numeroBait: String
    private let nombre: String
    private let apellidos: String
    private let adicional: String
    private let email: String
    private let iccid: String
    private let auto: Int = 1
    
    public init(compania: String, numActual: String, imei: String, nip: String, numBait: String, nombre: String, apellidos: String, adicional: String, email: String, iccid: String) {
        self.compania = compania
        self.numeroActual = numActual
        self.imei = imei
        self.nip = nip
        self.numeroBait = numBait
        self.nombre = nombre
        self.apellidos = apellidos
        self.adicional = adicional
        self.email = email
        self.iccid = iccid
    }
}

///Atributos de response
public struct PortabilityResponse: Decodable {
    public let estado: Bool?
    public let numero: String?
    public let folio: String?
    public let mensaje: String?
}

//TODO: Modelo del servicio de Redencion Ticket
///Atributos de request
public struct RedencionTicketRequest: Encodable {
    private let access: String
    private let numero_ticket: String
    private let comercio: String
    private let total: String
    private let base64: String
    
    public init(access: String, numero_ticket: String, comercio: String, total: String, base64: String) {
        self.access = access
        self.numero_ticket = numero_ticket
        self.comercio = comercio
        self.total = total
        self.base64 = base64
    }
}

///Atributos de response
public struct RedencionTicketResponse: Decodable {
    public let success: Bool?
    public let mensaje: String?
}

//TODO: Modelo del servicio de Cerrar Sesión
///Atributos de request
public struct LogOutRequest: Encodable {
    internal let operacion: String = "logout"
    internal let access: String
    
    public init(access: String) {
        self.access = access
    }
}

//TODO: Modelo del servicio de Validar Número Bait
///Atributos de request
internal struct ValidateBaitRequest: Encodable {
    let tipo: Int = 1
    let dn: String?
    let iccid: String?
    let accion: String
}

///Atributos de response
public struct ValidateBaitResponse: Decodable {
    public let success: Bool?
    public let mensaje: String?
    public let status: Int?
    public let dn: String?
}

//TODO: Modelo del servicio de Reemplazo de SIM
///Atributos de request
public struct ReplaceSimRequest: Encodable {
    private let dn: String
    private let iccid: String
    private let email: String
    private let reason: Int
    
    init(dn: String, iccid: String, email: String, reason: RemplaceSimBait) {
        self.dn = dn
        self.iccid = iccid
        self.email = email
        self.reason = reason.rawValue
    }
}

///Atributos de response
public struct ReplaceSimResponse: Decodable {
    public let success: Bool?
    public let message: String?
    public let uuid: String?
}

//TODO: Modelo del servicio de Reemplazo de SIM
///Atributos de request  - Envio de OTP
public struct SendSimOtpRequest: Encodable {
    public let dn: String
}

///Atributos de request - Validar OTP
public struct ValidateSimOtpRequest: Encodable {
    public let dn: String
    public let code: String
}

//TODO: Modelo del servicio de cambio de código de área
///Atributos de request
public struct UpdateNirRequest: Encodable {
    public let nir: String
    public let numero: String
    internal let operacion: String = "confirmacion_nir"
    internal let origen: String = "ios"
    public let uuid: String
}

///Atributos de response
public struct UpdateNirResponse: Decodable {
    public let success: Bool?
    public let detalle: String?
    public let idusuario: Int?
}

// MARK: - ⚠️ typealias & Objects PUT/PATCH ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
