//
//  FetchMovies.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import Foundation

class FetchMovies {
    
    func getMovies(withURL url: String, completion: @escaping ([Movie]) -> Void) {
        var movies = [Movie]()
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                if let fetchedMovies = try JSONDecoder().decode(JsonAPI.self, from: data).results {
                    movies = fetchedMovies
                    completion(movies)
                }
                completion(movies)
            } catch {
                debugPrint(error.localizedDescription)
                completion(movies)
            } 
        }.resume()
    }
    
    
    func getLatestMovie(withURL url: String, completion: @escaping (Movie) -> Void) {
        var movie = Movie()
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(movie)
            } catch {
                debugPrint(error.localizedDescription)
                completion(Movie())
            }
            
        }.resume()
    }
    
    func getMovieByID(id: String, completion: @escaping (Movie) -> Void) {
        var movie = Movie()
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(Constants.API_KEY)&language=en-US"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(movie)
            } catch {
                debugPrint(error.localizedDescription)
                completion(Movie())
            }
            
            }.resume()
    }
}




