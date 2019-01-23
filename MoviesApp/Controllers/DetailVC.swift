//
//  DetailVC.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, SelectMovieDelegate {
    
    private var id: String?
    private var movieTitle: String?
    private var poster: String?
    private var thumbnail: String?
    private var vote: String?
    private var plot: String?
    private var year: String?

    @IBOutlet weak var posterImageview: UIImageView! {
        didSet {
            let posterURL = URL(string: poster!)
            if let posterData = try? Data(contentsOf: posterURL!) {
                posterImageview.image = UIImage(data: posterData)
            }
        }
    }
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            let thumbnailURL = URL(string: thumbnail!)
            if let thumbnailData = try? Data(contentsOf: thumbnailURL!) {
                thumbnailImageView.image = UIImage(data: thumbnailData)
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = movieTitle
        }
    }
    @IBOutlet weak var yearLabel: UILabel! {
        didSet {
            yearLabel.text = year
        }
    }
    @IBOutlet weak var ratingLabel: UILabel! {
        didSet {
            ratingLabel.text = vote
        }
    }
    @IBOutlet weak var plotLabel: UILabel! {
        didSet {
            plotLabel.text = plot
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = movieTitle
    }
    

    
    @IBAction func playAction(_ sender: UIButton) {
        debugPrint("Played...")
    }
    
    func selectMovie(id: Int, title: String, poster: String, thumbnail: String, vote: Double, plot: String, year: String) {
        self.id = String(id)
        self.movieTitle = title
        self.poster = poster
        self.thumbnail = thumbnail
        self.vote = String(vote)
        self.plot = plot
        self.year = String(year.prefix(4))
    }
    
}
