//
//  ImageTableViewCell.swift
//  Komoot
//
//  Created by Ani Eduard on 24/10/2019.
//  Copyright © 2019 Ani Eduard. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    var _image: UIImage? {
        didSet {
            _imageView.image = _image
        }
    }
    
    // MARK: - Private properties
    
    private let _imageView = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func initView() {
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(_imageView)
        
        let constraints: [NSLayoutConstraint] = [
            _imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .padding),
            _imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.padding),
            _imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .padding),
            _imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.padding),
            _imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ]
        constraints.forEach { $0.priority = .required - 1 }
        NSLayoutConstraint.activate(constraints)
    }
}
