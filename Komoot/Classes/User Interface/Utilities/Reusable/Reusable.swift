//
//  Reusable.swift
//  Komoot
//
//  Created by Ani Eduard on 24/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
