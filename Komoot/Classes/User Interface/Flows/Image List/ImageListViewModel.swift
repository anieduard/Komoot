//
//  ImageListViewModel.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit
import struct CoreLocation.CLLocationCoordinate2D

protocol ImageListViewModelFlowDelegate: AnyObject {
    func shouldShowError(_ error: Error, on viewModel: ImageListViewModel)
}

protocol ImageListViewModel: AnyObject {
    var reloadData: ((ImageListViewModelImpl.DataSourceType) -> Void)? { get set }
    
    func didTouchStart()
    func didTouchStop()
}

final class ImageListViewModelImpl: ImageListViewModel {
    
    typealias DataSourceType = NSDiffableDataSourceSnapshot<Section, UIImage?>
    
    // MARK: - Public properties
    
    weak var flowDelegate: ImageListViewModelFlowDelegate?
    
    var reloadData: ((DataSourceType) -> Void)?
    
    // MARK: - Private properties
    
    private let locationService: LocationService
    private let imageService: ImageService
    private var dataSourceSnapshot: DataSourceType
    
    // MARK: - Init
    
    init() {
        locationService = LocationService()
        imageService = ImageService()
        dataSourceSnapshot = DataSourceType()
        
        locationService.delegate = self
        dataSourceSnapshot.appendSections(Section.allCases)
    }
    
    // MARK: - Logic
    
    private func fetchPhoto(for coordinates: CLLocationCoordinate2D) {
        imageService.fetchPhoto(for: coordinates) { [weak self, weak imageService] result in
            switch result {
            case .success(let photo):
                imageService?.fetchImage(from: photo) { result in
                    switch result {
                    case .success(let image):
                        guard let self = self else { return }
                        self.dataSourceSnapshot.appendItems([image], toSection: .images)
                        self.reloadData?(self.dataSourceSnapshot)
                    case .failure(let error):
                        guard let self = self else { return }
                        self.flowDelegate?.shouldShowError(error, on: self)
                    }
                }
            case .failure(let error):
                guard let self = self else { return }
                self.flowDelegate?.shouldShowError(error, on: self)
            }
        }
    }
    
    // MARK: - User interaction
    
    func didTouchStart() {
        locationService.startUpdatingLocation()
    }
    
    func didTouchStop() {
        locationService.stopUpdatingLocation()
    }
}

// MARK: - LocationServiceDelegate

extension ImageListViewModelImpl: LocationServiceDelegate {
    
    func userDidPassThreshold(with coordinate: CLLocationCoordinate2D) {
        fetchPhoto(for: coordinate)
    }
}

// MARK: - Section

extension ImageListViewModelImpl {
    
    enum Section: CaseIterable {
        case images
    }
}
