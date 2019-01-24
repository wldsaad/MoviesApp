//
//  TrailerCell.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class TrailerCell: UITableViewCell {

    private var trailerView: TrailerXibView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView(){
        trailerView = Bundle.main.loadNibNamed("TrailerXib", owner: self, options: nil)?.first as? TrailerXibView
        trailerView?.frame = self.frame
        if trailerView != nil {
            self.addSubview(trailerView!)
        }
    }
    
    func updateView(trailer: Trailer, imageURL: String) {
        trailerView?.trailerTitleLabel.text = trailer.name
        let imageURLString = "http://image.tmdb.org/t/p/w185/\(imageURL)"
            if let url = URL(string: imageURLString) {
                do {
                    let imageData = try Data(contentsOf: url)
                    trailerView?.trailerImageView.image = UIImage(data: imageData)
                } catch {
                    debugPrint(error.localizedDescription)
                }
                
            }
        
        
    }
}
