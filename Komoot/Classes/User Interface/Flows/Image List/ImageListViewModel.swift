//
//  ImageListViewModel.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation
import CoreLocation

protocol ImageListViewModel: AnyObject {
    func fetchPhoto(for coordinates: CLLocationCoordinate2D)
}

final class ImageListViewModelImpl: ImageListViewModel {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private let imageService: ImageService
    
    // MARK: - Init
    
    init() {
        self.imageService = ImageService()
    }
    
    // MARK: - Logic
    
    func fetchPhoto(for coordinates: CLLocationCoordinate2D) {
        imageService.fetchPhoto(for: coordinates) { result in
            print(result)
        }
    }
}
