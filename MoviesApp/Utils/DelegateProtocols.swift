//
//  DelegateProtocols.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import Foundation

protocol SelectMovieDelegate {
    func selectMovie(id: Int, title: String, poster: String, thumbnail: String, vote: Double, plot: String, year: String)
}
