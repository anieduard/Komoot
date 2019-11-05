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
    
    func performRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status < 200 || status > 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(request) { result in
            do {
                let object = try JSONDecoder().decode(T.self, from: result.get())
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
