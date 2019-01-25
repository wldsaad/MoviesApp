//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    private var movieView: MovieXibView?
    
    override func awakeFromNib() {
        initCell()
    }
    
    //initialize movie xib
    private func initCell() {
        movieView = Bundle.main.loadNibNamed("MovieXib", owner: self, options: nil)?.first as? MovieXibView
        movieView?.frame = self.frame
        if movieView != nil {
            self.addSubview(movieView!)
        }
    }
    
    //update movie xib
    func updateCellView(movie: Movie) {
        guard let moviePosterPath = movie.poster_path else {
            return
        }
        let imageURLString = "http://image.tmdb.org/t/p/w185/\(moviePosterPath)"
        let imageURL = URL(string: imageURLString)
        if let imageData = try? Data(contentsOf: imageURL!) {
            self.movieView?.movieImageView.image = UIImage(data: imageData)
        }
    }
    
}
