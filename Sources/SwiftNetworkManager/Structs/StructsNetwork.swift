//
//  StructsNetworConsswift
//  NetworkManagerSDK
//
//  Created by Javier Picazo Hernandez on 10/06/24.
//

import Foundation

//TODO: Catálogo de solicitud de métodos HTTP
internal struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let head = HTTPMethod(rawValue: "HEAD")
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let query = HTTPMethod(rawValue: "QUERY")
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

//TODO: Constantes
internal struct Cons {
    static let ordServicio = "ordServicio"
    static let ordServicioValue = "57bfb26735aa4ec3a1baafa864006d7d"
    static let origen = "Origen"
    static let origin = "Origin"
    static let origenValue = "ios.mibait.com"
    static let app = "app-version"
    static let pListName = "CDN"
    static let uuidPaymentiOS = "b50cc2f484e111ee87cf0242ac120002"
    static let error2 = -2
    static let error0 = 0
    static let ordForm = "ordForm"
    static let ordFormValue = "19aaf7e82b0d11eea85000155d0a1e12"
    static let uuidHeader = "x-ord-crsf"
    static let iOS = "ios"
}
