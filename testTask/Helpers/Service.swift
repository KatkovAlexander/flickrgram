//
//  Service.swift
//  testTask
//
//  Created by Александр Катков on 27.08.2022.
//

import Foundation

class Service {
    
    static let url = URL(string: "https://www.flickr.com/services/rest/")!
    
    static let photoCategories = ["cat", "dog", "car", "hill", "computer"]
    
    static func getParametrs(category: String) -> [String: String] {
        let parametrs = [
            "method": "flickr.photos.search",
            "api_key": "78b371ae0c190ea9019b5995f8b2aa7b",
            "sort": "relevance",
            "per_page": "20",
            "format": "json",
            "nojsoncallback": "1",
            "extras": "url_q",
            "text": "\(category)"
        ]
        
        return parametrs
    }
}
