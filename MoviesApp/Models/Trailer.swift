//
//  Video.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import Foundation

struct TrailersApi: Decodable {
    var results: [Trailer]?
}

struct Trailer: Decodable {
    var id: String?
    var key: String?
    var name: String?
    var site: String?

}

