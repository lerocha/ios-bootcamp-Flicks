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
    var voteAgerage: Double = 0
    var voteCount: CLongLong = 0
    var year: Int = 0
    var releaseDate: Date?
    var smallPosterUrl: URL?
    var posterUrl: URL?
    
    override init() {
        
    }
    
    init(movie: NSDictionary) {
        title = movie["title"] as! String
        overview = movie["overview"] as! String
        posterPath = movie["poster_path"] as! String
        voteAgerage = movie["vote_average"] as! Double
        voteCount = movie["vote_count"] as! CLongLong
        smallPosterUrl = URL(string: "https://image.tmdb.org/t/p/w45/\(posterPath)");
        posterUrl = URL(string: "https://image.tmdb.org/t/p/w342/\(posterPath)");

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-DD"
        if let date = dateFormater.date(from: movie["release_date"] as! String) {
            releaseDate = date
            let calendar = Calendar.current
            year = calendar.component(.year, from: date)
        }
    }
}
