//
//  FailableDecodable.swift
//  Komoot
//
//  Created by Ani Eduard on 27/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        base = try? container.decode(Base.self)
    }
}

struct FailableDecodableArray<Element: Decodable>: Decodable {
    
    let elements: [Element]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        elements = try container.decode([FailableDecodable<Element>].self).compactMap { $0.base }
    }
}
