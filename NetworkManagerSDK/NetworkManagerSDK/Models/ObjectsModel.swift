//
//  ObjectsModel.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import Foundation

// MARK: - ⚠️ typealias & Objects GET ::::::::::::::::
public typealias CallbackResponseTarget = (_ response: ServiceClass?, _ error: ErrorResponse?) -> ()
public struct WidgetService: Codable {
    public let version: String?
    public let change_date: String?
    public let service_order: [String]?
    public let stores_order: [String]?
    public let stores: [StoreService]?
    public let services: [StoreService]?
}

public struct StoreService: Codable {
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

// MARK: - ⚠️ typealias & Objects POST ::::::::::::::::

// MARK: - ⚠️ typealias & Objects PUT ::::::::::::::::

// MARK: - ⚠️ typealias & Objects DELETE ::::::::::::::::
