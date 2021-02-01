//
//  FavoriteMovieController.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/31/21.
//

import Foundation

class FavoriteController {
    // MARK: - properties
    static let shared = FavoriteController()
    var favorites: [Favorite] = []
    var favoriteShows: [Favorite] = []
    var favoriteMovies: [Favorite] = []
    
    // MARK: - CRUD
    func addToFavorites(media: Media) {
        let favorite: Favorite
        //create a new favorite based on the media type it contains
        if media.mediaType == "movie" {
            favorite = Favorite(title: media.title ?? "unknown", voteAverage: media.voteAverage ?? 0.0, posterPath: media.posterPath, id: media.id, mediaType: media.mediaType)
        } else {
            favorite = Favorite(title: media.name ?? "unknown", voteAverage: media.voteAverage ?? 0.0, posterPath: media.posterPath, id: media.id, mediaType: media.mediaType)
        }
        favorites.append(favorite)
        favorites = favorites.removeDuplicates()
        sortFavorites()
        saveToPersistentStorage()
    }
    
    func sortFavorites() {
        favoriteMovies = favorites.filter({ (media) -> Bool in
            return media.mediaType == "movie"
        })
        favoriteShows = favorites.filter({ (media) -> Bool in
            return media.mediaType == "tv"
        })
        saveToPersistentStorage()
    }
    
    func delete(media: Favorite) {
        guard let mediaToDelete = favorites.firstIndex(of: media) else {return}
        favorites.remove(at: mediaToDelete)
        sortFavorites()
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("MovieSearch.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: fileURL())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistentStorage() {
        do {
            let data = try Data(contentsOf: fileURL())
            favorites = try JSONDecoder().decode([Favorite].self, from: data)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
