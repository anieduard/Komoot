//
//  NetworkManager.swift
//  Komoot
//
//  Created by Ani Eduard on 27/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    // MARK: - Public properties
    
    private(set) lazy var baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = APIConstants.URL.scheme
        components.host = APIConstants.URL.host
        components.path = APIConstants.URL.path
        return components
    }()
    
    // MARK: - Private properties
    
    private let session: URLSession
    
    // MARK: - Init
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Logic
    
    func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status < 200 || status > 300 {
                completion(.failure(NetworkError.httpError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case httpError
    case noData
    
    var localizedDescription: String {
        switch self {
        case .httpError:
            return "Something went wrong. Please try again."
        case .noData:
            return "The server returned no data."
        }
    }
}
