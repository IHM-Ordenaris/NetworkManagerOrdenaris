//
//  StructsObjects.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

public struct ServicesPlugInResponse {
    public var status: statusService
    public var response: responseService
    
    init() {
        status = .start
        response = .request
    }
    
    init(_ status: statusService, response: responseService = .request) {
        self.status = status
        self.response = response
    }
}
