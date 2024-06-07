//
//  WebService.swift
//  NetworkManagerSDK
//
//  Created by Ignacio Hernandez Montes on 07/06/24.
//

import UIKit
import Foundation

/// WebService implementa las funciones para las llamadas a servicios
/// Una instancia de esta clasedará acceso a las funciones para obtención de datos desde Servicio
public class WebService {
    /// Notificación de estatus de llamada a servicio (start / finish)
    public var callbackServices: ((ServicesPlugInResponse) -> Void)?
    
    public init () {
        /// Inicializador
    }
    
    // MARK: - ⚠️ Métodos GET ::::::::::::::::
    /// Función obtener status token device
    ///  ```
    /// func getCuentasById(idAccount:String, callback: { response, error in }
    /// ```
    /// - Parameters:
    ///   - idAccount: - identificador de cuenta
    ///   - callback: ObjResponseGetCharacters (⎷ response) / ErrorResponseGral (⌀ error)
    public func getCharacters(callback: @escaping CallbackResponseGetCharacters) {
        self.callbackServices?(ServicesPlugInResponse(.start))
        
        let urlStr: String = Service.GetCharacters.API
        let headers: [Headers] = []
        let service = Servicio(nombre: Service.GetCharacters.NAME, headers: headers, url: urlStr)
        service.printResponse = true
        var params = [String: Any]()
        
        Network().methodGet(servicio: service, params: params) { response, failure in
            if let error = failure {
                callback(ObjResponseGetCharacters(), error)
                self.callbackServices?(ServicesPlugInResponse(.finish, response: .error))
                return
            } else {
                let decoder = JSONDecoder()
                do {
                    let datos = response!.data!
                    let decodedResponse = try decoder.decode(ObjResponseGetCharacters.self, from: datos)
                    callback(decodedResponse, nil)
                } catch {
                    callback(ObjResponseGetCharacters(), ErrorResponse())
                }
                self.callbackServices?(ServicesPlugInResponse(.finish))
            }
        }
    }
}
    
