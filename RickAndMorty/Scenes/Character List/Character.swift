//
//  Character.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import Foundation

// MARK: - Character
struct Character: Codable {
    var info: Info?
    var results: [ResultModel]?
}

// MARK: - Info
struct Info: Codable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
}

// MARK: - Result
struct ResultModel: Codable {
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin, location: Location?
    var image: String?
    var episode: [String]?
}

// MARK: - Location
struct Location: Codable {
    var name: String?
    var url: String?
}
