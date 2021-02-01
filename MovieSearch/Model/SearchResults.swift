//
//  MovieSearchResults.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import Foundation

struct SearchResults: Codable {
    let results: [Media]
}

struct Media: Codable {
    let title: String?
    let name: String?
    let mediaType: String
    let overview: String?
    let voteAverage: Double?
    let posterPath: String?
    let id: Int
 
    enum CodingKeys: String, CodingKey {
        case overview, id, title, name
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case mediaType = "media_type"
    }
}


