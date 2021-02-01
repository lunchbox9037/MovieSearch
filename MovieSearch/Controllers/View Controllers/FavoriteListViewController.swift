//
//  FavoriteListViewController.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/31/21.
//

import UIKit

class FavoriteListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // MARK: - Properties
    var favorites: [Favorite] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FavoriteController.shared.loadFromPersistentStorage()
        favorites = FavoriteController.shared.favoriteMovies
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FavoriteController.shared.sortFavorites()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            favorites = FavoriteController.shared.favoriteMovies
            tableView.reloadData()
        case 1:
            favorites = FavoriteController.shared.favoriteShows
            tableView.reloadData()
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            favorites = FavoriteController.shared.favoriteMovies
            tableView.reloadData()
        case 1:
            favorites = FavoriteController.shared.favoriteShows
            tableView.reloadData()
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}//end class

// MARK: - Tableview Source Extension
extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else {return UITableViewCell()}
        cell.favorite = favorites[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteToDelete = favorites[indexPath.row]
            favorites.remove(at: indexPath.row)
            FavoriteController.shared.delete(media: favoriteToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
