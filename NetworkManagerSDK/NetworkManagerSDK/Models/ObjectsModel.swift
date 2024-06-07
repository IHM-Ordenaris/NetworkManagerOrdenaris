//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - ⚠️ typealias & Objects GET ::::::::::::::::
public typealias CallbackResponseGetCharacters = (_ response: ObjResponseGetCharacters, _ error: ErrorResponseGral?) -> ()

// MARK: - :::: Objetos response ERROR GRAL ::::
public class ErrorResponseGral: Codable, Error {
    public var statusCode: Int
    public var responseCode: Int
    public var errorMessage: String
    
    enum CodingKeys: Int, CodingKey {
        case statusCode
        case responseCode
        case errorMessage
    }
    
    init() {
        statusCode = 0
        responseCode = 0
        errorMessage = ""
    }
}

final public class ObjResponseGetCharacters: Codable {
    public var info: ObjInfoCharacter
    public var results: [ObjCharacter]
    
    init(){
        self.info = ObjInfoCharacter()
        self.results = []
    }
}

final public class ObjInfoCharacter: Codable {
    public var count: Int
    public var pages: Int
    public var next: String
    
    init() {
        self.count = 0
        self.pages = 0
        self.next = ""
    }
}

final public class ObjCharacter: Codable {
    public var id: Int
    public var name: String
    public var status: Int
    public var species: String
    public var type: String
    public var gender: String
    public var image: String
    
    init() {
        self.id = 0
        self.name = ""
        self.status = 0
        self.species = ""
        self.type = ""
        self.gender = ""
        self.image = ""
    }
}

// MARK: - ⚠️ typealias & Objects POST ::::::::::::::::

// MARK: - ⚠️ typealias & Objects PUT ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
