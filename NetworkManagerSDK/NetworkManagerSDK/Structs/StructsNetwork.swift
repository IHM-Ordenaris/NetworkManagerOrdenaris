//
//  StructsNetwork.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 10/06/24.
//

import Foundation

// Enumeraciòn para metodo de request
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

internal struct K {
    static let ordServicio = "ordServicio"
    static let ordServicioValue = "57bfb26735aa4ec3a1baafa864006d7d"
    static let origen = "Origen"
    static let origin = "Origin"
    static let origenValue = "ios.mibait.com"
    static let app = "app-version"
    static let pListName = "CDN"
}
