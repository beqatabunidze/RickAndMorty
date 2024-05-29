//
//  APIEndpoints.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import Foundation

enum CharacterEndpoint: Endpoint {
    case getAllCharacters(page: Int?)
    case searchCharacters(name: String)
    
    var path: String {
        switch self {
        case .getAllCharacters:
            "/api/character"
        case .searchCharacters:
            "/api/character"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .getAllCharacters(let page):
            return [URLQueryItem(name: "page", value: "\(page ?? 1)")]
        case .searchCharacters(let name):
            return [URLQueryItem(name: "name", value: name)]
        }
    }
}

enum EpisodeEndpoint: Endpoint {
    case getSelectedEpisodes(index: Int)
    
    var path: String {
        switch self {
        case .getSelectedEpisodes(let index):
            "/api/episode/\(index)"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .getSelectedEpisodes:
            return nil
        }
    }
}
