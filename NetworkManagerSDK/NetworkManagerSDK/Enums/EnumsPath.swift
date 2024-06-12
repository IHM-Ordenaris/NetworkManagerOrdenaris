//
//  EnumsPath.swift
//  NetworkManagerSDK
//
//  Created by Desarrollador iOS on 10/06/24.
//

import Foundation

/// Lista de servicios a consultar
public enum ServiceName: String{
    case version
}


public enum ServiceClass{
    case version(Servicio)
    case widget(General)
}
