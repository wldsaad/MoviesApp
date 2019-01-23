//
//  Movie.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import Foundation

struct JsonAPI: Decodable {
    var results: [Movie]?
}

struct Movie: Decodable {
    var id: Int?
    var vote_average: Double?
    var original_title: String?
    var overview: String?
    var release_date: String?
    var poster_path: String?
    var backdrop_path: String?

}
