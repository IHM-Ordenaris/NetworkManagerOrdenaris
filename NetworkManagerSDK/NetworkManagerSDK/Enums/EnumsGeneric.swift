//
//  EnumsGeneric.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// Enumeraciòn para estatus de servicio
public enum StatusService: Int {
    case start = 1
    case finish = 2
}

// Enumeraciòn para estatus de servicio
public enum ResponseService {
    case request
    case success
    case error
}

// Enumeraciòn para metodo de request
public enum MethodRequest: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
