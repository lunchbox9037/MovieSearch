//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by stanley phillips on 1/29/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // MARK: - Properties
    var movie: Movie? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let movie = movie else {return}
        titleLabel.text = movie.title
        ratingLabel.text = "Rating: \(movie.voteAverage)"
        overviewLabel.text = movie.overview
        SearchResultsController.fetchPosterFor(movie: movie) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self.posterImageView.image = poster
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
