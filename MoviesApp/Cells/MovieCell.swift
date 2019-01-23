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
    
    private func initCell() {
        movieView = Bundle.main.loadNibNamed("MovieXib", owner: self, options: nil)?.first as? MovieXibView
        movieView?.frame = self.frame
        if movieView != nil {
            self.addSubview(movieView!)
        }
    }
    
    
    
}
