//
//  DetailVC.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController, SelectMovieDelegate {
    
    private var id: String? {
        didSet {
            loadMovieByID(id: id!)
        }
    }
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
   
    @IBOutlet weak var favButton: UIButton!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var selectedMovie: MyMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = movieTitle
        handleFavButtonState()
        
    }
    
    private func loadMovieByID(id: String) {
        let request: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let movies = try context.fetch(request)
            if movies.count > 0 {
                self.selectedMovie = movies[0]
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func handleFavButtonState() {
        if selectedMovie != nil {
            favButton.tag = 1
            favButton.tintColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        } else {
            favButton.tag = 0
            favButton.tintColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        }
    }
    
    @IBAction func handleFavAction(_ sender: UIButton) {

        if sender.tag == 1 {
            deleteMovie(movie: selectedMovie!)
            UIView.animate(withDuration: 0.3) {
                sender.tintColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                sender.tag = 0
            }
            return
        }
        let movie = MyMovie(context: context)
        movie.id = id
        movie.backdrop_path = thumbnail
        movie.original_title = movieTitle
        movie.overview = plot
        movie.poster_path = poster
        movie.release_date = year
        movie.vote_average = vote
        saveMovie(movie: movie)
        UIView.animate(withDuration: 0.3) {
            sender.tintColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
            sender.tag = 1
        }
        
        
    }
    
    private func deleteMovie(movie: MyMovie) {
        do {
            context.delete(movie)
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
       
    }
    
    private func saveMovie(movie: MyMovie){
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
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
