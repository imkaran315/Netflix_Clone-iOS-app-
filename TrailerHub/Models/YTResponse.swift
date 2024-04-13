//
//  YTResponse.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 07/03/24.
//

import Foundation

struct YTResponse: Codable {
    let items : [VideoElement]
}

struct VideoElement : Codable {
    let id : YTId
}

struct YTId : Codable {
    let kind : String?
    let videoId : String?
}
