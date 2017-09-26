//
//  Movies.swift
//  NYTimesMovies
//
//  Created by Viola Pirri on 9/25/17.
//  Copyright © 2017 Viola Pirri. All rights reserved.
//

import Foundation

class Movies {
    
    let title: String
    let media: String
    let reviewLink: String
    
    init(title: String, media: String, reviewLink: String) {
        self.title = title
        self.media = media
        self.reviewLink = reviewLink
    }
}
