//
//  Movie.swift
//  Flicks
//
//  Created by Rocha, Luis on 4/1/17.
//  Copyright © 2017 Luis Rocha. All rights reserved.
//

import Foundation

class Movie : NSObject {
    
    var title: String = ""
    var overview: String = ""
    var posterPath: String = ""
    var smallPosterUrl: URL?
    var posterUrl: URL?
    
    override init() {
        
    }
    
    init(movie: NSDictionary) {
        title = movie["title"] as! String
        overview = movie["overview"] as! String
        posterPath = movie["poster_path"] as! String
        smallPosterUrl = URL(string: "https://image.tmdb.org/t/p/w45/\(posterPath)");
        posterUrl = URL(string: "https://image.tmdb.org/t/p/w342/\(posterPath)");
    }
}
