//
//  Photos.swift
//  Komoot
//
//  Created by Ani Eduard on 27/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
    
    let photos: FailableDecodableArray<Photo>
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        photos = try container.decode(FailableDecodableArray.self, forKey: .photos)
    }
}
