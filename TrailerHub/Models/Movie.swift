//
//  Movie.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 28/02/24.
//

import Foundation

struct TrendingMoviesResponse: Codable{
    let results : [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}



/// Remaining Things to implement in the app
///    1 HeaderView to Play the title
///    2 HeaderView to Save the title
///
///    4 Configure Save Button to save the title from Title Preview Screen
///
///     Done -
///     3 Search Results cell to play directly through context menu config

