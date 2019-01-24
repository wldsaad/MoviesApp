//
//  ReviewCell.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    private var reviewView: ReviewXibView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView(){
        reviewView = Bundle.main.loadNibNamed("ReviewXib", owner: self, options: nil)?.first as? ReviewXibView
        reviewView?.frame = self.frame
        if reviewView != nil {
            self.addSubview(reviewView!)
        }
    }
    
    func updateView(review: Review) {
        reviewView?.reviewAuthorLabel.text = review.author
        reviewView?.reviewContentLabel.text = review.content
    }

}
