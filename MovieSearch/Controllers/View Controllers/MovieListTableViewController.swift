//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var movies: [Movie] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        cell.movie = movies[indexPath.row]
        return cell
    }
}

// MARK: - Search Bar delegate
extension MovieListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.capitalized else {return}
        SearchResultsController.fetchMovieSearchResultsFor(movie: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.movies = results
                    self.searchBar.text = ""
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
