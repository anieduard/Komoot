//
//  ImageListViewModel.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

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
    
    private let imageService: ImageService
    private var dataSourceSnapshot: DataSourceType
    
    // MARK: - Init
    
    init() {
        self.imageService = ImageService()
        
        dataSourceSnapshot = DataSourceType()
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
        fetchPhoto(for: CLLocationCoordinate2D(latitude: 10, longitude: 20))
    }
    
    func didTouchStop() {
        
    }
}

extension ImageListViewModelImpl {
    
    enum Section: CaseIterable {
        case images
    }
}
