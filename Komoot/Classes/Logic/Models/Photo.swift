//
//  Photo.swift
//  Komoot
//
//  Created by Ani Eduard on 27/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case url = "url_m"
    }
    
    let url: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        url = try container.decode(URL.self, forKey: .url)
    }
}
