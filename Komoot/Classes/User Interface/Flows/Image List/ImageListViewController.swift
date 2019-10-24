//
//  ImageListViewController.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: ImageListViewModel
    private let tableView = UITableView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Image> = {
        UITableViewDiffableDataSource<Section, Image>(tableView: tableView) { tableView, indexPath, image in
            let cell: ImageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = image.name
            return cell
        }
    }()
    
    // MARK: - Init
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .start, style: .plain, target: self, action: #selector(rightBarButtonItemTouched))
        
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(cellType: ImageTableViewCell.self)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([Image(name: "a"), Image(name: "b"), Image(name: "c")], toSection: .images)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Bindings
    
    // MARK: - User interaction
    
    @objc private func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        if sender.title == .start {
            sender.title = .stop
            startButtonTouched()
        } else if sender.title == .stop {
            sender.title = .start
            stopButtonTouched()
        }
    }
    
    private func startButtonTouched() {
        
    }
    
    private func stopButtonTouched() {
        
    }
}

private extension ImageListViewController {
    
    enum Section: CaseIterable {
        case images
    }

    struct Image: Hashable {
        let name: String
    }
}

// MARK: - Constants

private extension String {
    static let start = "Start"
    static let stop = "Stop"
}
