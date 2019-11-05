//
//  Coordinator.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    
    func start()
}

extension Coordinator {
    
    @discardableResult
    func showAlertController(on viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction] = [.ok]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alertController.addAction)
        viewController.present(alertController, animated: true)
        
        return alertController
    }
}

// MARK: - Constants

extension UIAlertAction {
    static let ok = UIAlertAction(title: "Ok", style: .default)
}
