//
//  ImageListViewController.swift
//  Komoot
//
//  Created by Ani Eduard on 22/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit
import CoreLocation

final class ImageListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: ImageListViewModel
    private let tableView = UITableView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<ImageListViewModelImpl.Section, UIImage?> = {
        UITableViewDiffableDataSource<ImageListViewModelImpl.Section, UIImage?>(tableView: tableView) { tableView, indexPath, image in
            let cell: ImageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell._image = image
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
        initView()
        initBindings()
    }
    
    private func initView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .start, style: .plain, target: self, action: #selector(rightBarButtonItemTouched))
        
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(cellType: ImageTableViewCell.self)
    }
    
    // MARK: - Bindings
    
    private func initBindings() {
        viewModel.reloadData = { [weak self] dataSourceSnapshot in
            self?.dataSource.apply(dataSourceSnapshot, animatingDifferences: true)
        }
        
        viewModel.errorOcurred = { [weak self] error in
            self?.navigationItem.rightBarButtonItem?.title = .start
        }
    }
    
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
        viewModel.didTouchStart()
    }
    
    private func stopButtonTouched() {
        viewModel.didTouchStop()
    }
}

// MARK: - Constants

private extension String {
    static let start = "Start"
    static let stop = "Stop"
}
