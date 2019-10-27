//
//  ImageListCoordinator.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit

final class ImageListCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ImageListViewModelImpl()
        viewModel.flowDelegate = self
        let viewController = ImageListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

// MARK: - ImageListViewModelFlowDelegate

extension ImageListCoordinator: ImageListViewModelFlowDelegate {
    
    func shouldShowError(_ error: Error, on viewModel: ImageListViewModel) {
        let alertController = UIAlertController(title: "An error ocurred", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        navigationController.present(alertController, animated: true)
    }
}
