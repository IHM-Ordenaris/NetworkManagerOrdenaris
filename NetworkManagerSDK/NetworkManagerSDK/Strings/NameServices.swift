//
//  NameServices.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation
struct Service {
    struct General {
//        static var BASE_SERVER  = "https://rickandmortyapi.com/api"   //Prod
        static var BASE_SERVER  = "https://rickandmortyapi.com/api" // QA
    }
    
    /// Headers Request
    struct Headers {
        static let APPLICATION_JSON = "application/json"
    }
    
    /// Example
    struct GetCharacters {
        static let NAME = "getCharacters"
        static let API  = Service.General.BASE_SERVER + "/character"
    }
}
