//
//  StructsObjects.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

public struct ServicesPlugInResponse {
    public var status: StatusService
    public var response: ResponseService
    
    init() {
        status = .start
        response = .request
    }
    
    init(_ status: StatusService, response: ResponseService = .request) {
        self.status = status
        self.response = response
    }
}
