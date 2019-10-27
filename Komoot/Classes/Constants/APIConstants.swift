//
//  APIConstants.swift
//  Komoot
//
//  Created by Ani Eduard on 26/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

enum APIConstants {
    
    enum URL {
        static let scheme: String = "https"
        static let host: String   = "api.flickr.com"
        static let path: String   = "/services/rest"
    }
    
    enum Parameters {
        static let method: URLQueryItem         = URLQueryItem(name: "method", value: "flickr.photos.search")
        static let apiKey: URLQueryItem         = URLQueryItem(name: "api_key", value: "d300bbbbba9bd7a7223a35daa06050bb")
        static let extras: URLQueryItem         = URLQueryItem(name: "extras", value: "url_m")
        static let format: URLQueryItem         = URLQueryItem(name: "format", value: "json")
        static let noJsonCallback: URLQueryItem = URLQueryItem(name: "nojsoncallback", value: "1")
        static let safeSearch: URLQueryItem     = URLQueryItem(name: "safe_search", value: "1")
        static let radius: URLQueryItem         = URLQueryItem(name: "radius", value: "0.1")
        static let perPage: URLQueryItem        = URLQueryItem(name: "per_page", value: "1")
        
        static func lat(_ lat: Double) -> URLQueryItem {
            URLQueryItem(name: "lat", value: "\(lat)")
        }
        
        static func lon(_ lon: Double) -> URLQueryItem {
            URLQueryItem(name: "lon", value: "\(lon)")
        }
    }
}
