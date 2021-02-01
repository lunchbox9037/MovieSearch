//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import UIKit
protocol FavoriteButtonDelegate: AnyObject {
    func addFavorite(_ sender: SearchResultsTableViewCell)
}

class SearchResultsTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var media: Media? {
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: FavoriteButtonDelegate?
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        delegate?.addFavorite(self)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let media = media else {return}
        if media.mediaType == "movie" {
            titleLabel.text = media.title
        } else {
            titleLabel.text = media.name
        }
        ratingLabel.text = "Rating: \(media.voteAverage ?? 0)"
        overviewLabel.text = media.overview
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        SearchResultsController.fetchPosterFor(media: media) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.posterImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
