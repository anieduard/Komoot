//
//  ImageService.swift
//  Komoot
//
//  Created by Ani Eduard on 27/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation
import struct CoreLocation.CLLocationCoordinate2D
import class UIKit.UIImage

final class ImageService {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private let networkManager: NetworkManager
    
    // MARK: - Init
    
    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Logic
    
    private func flickrURL(from coordinates: CLLocationCoordinate2D) -> URL {
        var components = networkManager.baseURL
        
        let queryItems: [URLQueryItem] = [
            APIConstants.Parameters.method,
            APIConstants.Parameters.apiKey,
            APIConstants.Parameters.extras,
            APIConstants.Parameters.format,
            APIConstants.Parameters.noJsonCallback,
            APIConstants.Parameters.safeSearch,
            APIConstants.Parameters.radius,
            APIConstants.Parameters.perPage,
            APIConstants.Parameters.lat(coordinates.latitude),
            APIConstants.Parameters.lon(coordinates.longitude)
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else { fatalError("The URL couldn't be formed from the specified components: \(components).") }
        return url
    }
    
    func fetchPhoto(for coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Photo?, Error>) -> Void) {
        let request = URLRequest(url: flickrURL(from: coordinates))
        networkManager.performRequest(request) { (result: (Result<Response, Error>)) in
            completion(result.map { $0.photos.photos.elements.first })
        }
    }
    
    func fetchImage(from photo: Photo?, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let photo = photo else { completion(.failure(NetworkError.noData)); return }
        
        let request = URLRequest(url: photo.url)
        networkManager.performRequest(request) { result in
            completion(result.map { UIImage(data: $0) })
        }
    }
}
