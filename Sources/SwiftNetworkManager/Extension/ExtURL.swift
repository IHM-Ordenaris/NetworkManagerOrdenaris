//
//  ExtURL.swift
//  NetworkManager
//
//  Created by Javier Picazo Hernández on 04/06/24.
//  Copyright © 2024 Innovatia. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
    
    func getURLQueryKeysAndValues() -> [String: [String]]?{
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return nil
        }
        
        var keysAndValues = [String: [String]]()
        for queryItem in queryItems {
            if let name = queryItem.name.removingPercentEncoding {
                var values = keysAndValues[name] ?? []
                if let value = queryItem.value?.removingPercentEncoding {
                    values.append(value)
                }
                keysAndValues[name] = values
            }
        }
        
        return keysAndValues
    }
}
