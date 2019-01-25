//
//  FavCell.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class FavCell: UICollectionViewCell {
    
    private var favView: FavXibView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    //initialize fav xib
    private func initView(){
        favView = Bundle.main.loadNibNamed("FavXib", owner: self, options: nil)?.first as? FavXibView
        favView?.frame = self.frame
        if favView != nil {
            self.addSubview(favView!)
        }
    }
    
    //update fav xib
    func updateView(movie: MyMovie){
        favView?.movieTitleLabel.text = movie.title
        if let poster = movie.image {
            let imageURL = URL(string: poster)
            guard let imageData = try? Data(contentsOf: imageURL!) else {
                return
            }
            self.favView?.movieImageview.image = UIImage(data: imageData)
            
        }
        
    }
}
