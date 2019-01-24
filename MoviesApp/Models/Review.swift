//
//  Reviews.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import Foundation

struct ReviewsApi: Decodable {
    var results: [Review]?    
}

struct Review: Decodable {
    var author: String?
    var content: String?
}
