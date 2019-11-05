//
//  NetworkError.swift
//  Komoot
//
//  Created by Ani Eduard on 05/11/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import protocol Foundation.LocalizedError

enum NetworkError: LocalizedError {
    case httpError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .httpError:
            return "Something went wrong. Please try again."
        case .noData:
            return "The server returned no data."
        }
    }
}
