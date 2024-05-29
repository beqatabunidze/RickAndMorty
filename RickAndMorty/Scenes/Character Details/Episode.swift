//
//  Episode.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 28.05.24.
//

import Foundation

// MARK: - Episode
struct Episode: Codable {
    var id: Int?
    var name, airDate, episode: String?
    var characters: [String]?
    var url: String?
    var created: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
