//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var searchResults: [Media] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? SearchResultsTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.media = searchResults[indexPath.row]
        return cell
    }
}//end class

// MARK: - Search Bar delegate
extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.capitalized else {return}
        SearchResultsController.fetchSearchResultsFor(searchTerm: searchTerm) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.searchResults = results
                    self?.searchBar.text = ""
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Favorite Button Delegate
extension SearchResultsTableViewController: FavoriteButtonDelegate {
    func addFavorite(_ sender: SearchResultsTableViewCell) {
        guard let favorite = sender.media else {return}
        FavoriteController.shared.addToFavorites(media: favorite)
    }
}

