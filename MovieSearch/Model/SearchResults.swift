//
//  SearchResults.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import Foundation

struct SearchResults: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let overview: String
    let voteAverage: Double
    let posterPath: String?
    let isFavorite: Bool = false
 
    enum CodingKeys: String, CodingKey {
        case title, overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}

