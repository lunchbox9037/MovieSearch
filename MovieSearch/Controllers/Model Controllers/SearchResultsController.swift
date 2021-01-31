//
//  MovieController.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import UIKit
//base urlhttps://api.themoviedb.org/
//image urlhttp://image.tmdb.org/t/p/w500/(imageEndpoint)
//api_key = 48bcdd5f1ad8e7b88756b97c0c6c3c74
//example final urlhttps://api.themoviedb.org/3/search/movie?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74&query=Star%20Wars

class SearchResultsController {
    // MARK: - String Constants
    static let posterBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
    static let baseURL = URL(string: "https://api.themoviedb.org/")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    static let apiKey = "48bcdd5f1ad8e7b88756b97c0c6c3c74"
    
    static func fetchMovieSearchResultsFor(movie: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        let searchQuery = URLQueryItem(name: "query", value: movie)
        components?.queryItems = [apiQuery, searchQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("SEARCH RESULTS STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let results = try JSONDecoder().decode(SearchResults.self, from: data)
                var movies: [Movie] = []
                
                for movie in results.results {
                    movies.append(movie)
                }
                completion(.success(movies))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end of func
    
    static func fetchPosterFor(movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let posterBaseURL = posterBaseURL else {return completion(.failure(.invalidURL))}
        guard let posterPath = movie.posterPath else {return completion(.failure(.invalidURL))}
        let finalURL = posterBaseURL.appendingPathComponent(posterPath)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            guard let poster = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(poster))
        }.resume()
    }//end of func
}//end of class
