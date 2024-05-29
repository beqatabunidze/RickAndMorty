//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
}

extension Endpoint {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "rickandmortyapi.com"
    }
}
