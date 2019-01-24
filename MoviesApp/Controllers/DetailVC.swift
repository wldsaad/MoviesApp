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
    
    private var id: String?
    private var movieTitle: String?
    private var poster: String?
    private var thumbnail: String?
    private var vote: String?
    private var plot: String?
    private var year: String?
    @IBOutlet weak var posterImageview: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var trailersTableView: UITableView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let fetchMovies = FetchMovies()
    private var selectedMovie: MyMovie?
    private var currentMovie: Movie?
    private var trailers = [Trailer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = movieTitle
        loadMovieByID(id: id!)
        loadTrailersByID(id: id!)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFav(id: id!)

    }
    
    
    private func loadMovieByID(id: String) {
        
        fetchMovies.getMovieByID(id: id) { (movie) in
            self.currentMovie = movie
            DispatchQueue.main.async {
                self.updateViews(movie: self.currentMovie!)
            }
            self.checkFav(id: id)
        }
        
    }
    
    private func loadTrailersByID(id: String) {
        fetchMovies.getTrailersByID(id: id) { (trailers) in
            self.trailers = trailers
            DispatchQueue.main.async {
                self.trailersTableView.reloadData()
            }
        }
    }
    
    private func checkFav(id: String) {
        let request: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let movies = try context.fetch(request)
            if movies.count > 0 {
                self.selectedMovie = movies[0]
                DispatchQueue.main.async {
                    self.handleFavButtonState()
                }
            } else {
                DispatchQueue.main.async {
                    self.favButton.tag = 0
                    self.favButton.tintColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
                }
            }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func handleFavButtonState() {
        if selectedMovie != nil {
            self.favButton.tag = 1
            self.favButton.tintColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        } else {
            self.favButton.tag = 0
            self.favButton.tintColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
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
        if let movieID = currentMovie?.id {
            movie.id = String(movieID)
        }
        movie.title = currentMovie?.original_title
        if let imageURLString = currentMovie?.poster_path {
            movie.image = "http://image.tmdb.org/t/p/w185/\(imageURLString)"
        }
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
    
    private func updateViews(movie: Movie){

        let posterString = "http://image.tmdb.org/t/p/w185/\(movie.poster_path!)"
        let thumbnailString = "http://image.tmdb.org/t/p/w185/\(movie.backdrop_path!)"
        let posterURL = URL(string: posterString)
        if let posterData = try? Data(contentsOf: posterURL!) {
            posterImageview.image = UIImage(data: posterData)
        }
        let thumbnailURL = URL(string: thumbnailString)
        if let thumbnailData = try? Data(contentsOf: thumbnailURL!) {
            thumbnailImageView.image = UIImage(data: thumbnailData)
        }
        titleLabel.text = movie.original_title
        yearLabel.text = String((movie.release_date?.prefix(4))!)
        ratingLabel.text = "\(movie.vote_average!)"
        plotLabel.text = movie.overview
        handleFavButtonState()
        
    }
    
    func updateID(id: String){
        self.id = id
    }
    
}


extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == trailersTableView {
            return trailers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == trailersTableView {
            if let trailerCell = trailersTableView.dequeueReusableCell(withIdentifier: "trailerCell", for: indexPath) as? TrailerCell {
                if let movie = currentMovie {
                    trailerCell.updateView(trailer: trailers[indexPath.row], imageURL: movie.backdrop_path!)
                    return trailerCell
                }
                
            }
        }
        
        return UITableViewCell()
        
    }
    
    
}

extension DetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == trailersTableView {
            guard let key = trailers[indexPath.row].key else {
                return
            }
            let youTubeString = "https://www.youtube.com/watch?v=" + key
            let url = URL(string: youTubeString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
