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
    private weak var alertController: UIAlertController?
    
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
    
    private var canOpenSettings: Bool {
        guard let url: URL = .applicationURL else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func openSettings(action: UIAlertAction) {
        guard let url: URL = .applicationURL else { return }
        UIApplication.shared.open(url)
    }
    
    func shouldShowError(_ error: Error, on viewModel: ImageListViewModel) {
        guard alertController == nil else { return }
        
        let alertController = UIAlertController(title: "An error ocurred", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        navigationController.present(alertController, animated: true)
        self.alertController = alertController
    }
    
    func shouldShowLocationDisabledAlert(on viewModel: ImageListViewModel) {
        guard alertController == nil else { return }
        
        let alertController = UIAlertController(title: "Location Services are disabled", message: "Please allow Location Services in Settings.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: openSettings))
        navigationController.present(alertController, animated: true)
        self.alertController = alertController
    }
    
    func shouldShowLocationWhenInUseAlert(on viewModel: ImageListViewModel) {
        guard alertController == nil else { return }
        
        let alertController = UIAlertController(title: "Location Services are available only while in use", message: "Please Always Allow Location Services in Settings or use the app more until the iOS asks for permission in order to be able to use the app in the background as well.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: openSettings))
        navigationController.present(alertController, animated: true)
        self.alertController = alertController
    }
}

// MARK: - Constants

private extension URL {
    static let applicationURL = URL(string: UIApplication.openSettingsURLString)
}
