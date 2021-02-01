//
//  Movie.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/31/21.
//

import Foundation

class Favorite: Codable {
    let title: String
    let voteAverage: Double
    let posterPath: String?
    let id: Int
    let mediaType: String
    var isFavorite: Bool
    
    init(title: String, voteAverage: Double, posterPath: String?, id: Int, mediaType: String, isFavorite: Bool = true) {
        self.title = title
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.id = id
        self.mediaType = mediaType
        self.isFavorite = isFavorite
    }
}

extension Favorite: Equatable {
    static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        return lhs.title == rhs.title && lhs.isFavorite == rhs.isFavorite && lhs.id == rhs.id
    }
}
