//
//  FavoriteMovieTableViewCell.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/31/21.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    // MARK: - Properties
    var favorite: Favorite? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        guard let favorite = favorite else {return}
        titleLabel.text = favorite.title
        voteAverageLabel.text = "Rating: \(favorite.voteAverage)"
        SearchResultsController.fetchPosterForFavorite(media: favorite) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.posterImageView.image = image
                case .failure(_):
                    self?.posterImageView.image = UIImage(systemName: "trash")
                }
            }
        }
    }
}
