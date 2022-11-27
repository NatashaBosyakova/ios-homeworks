//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Наталья Босякова on 04.10.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var photosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .black
        label.text = "Photos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    private func setupView() {
        self.contentView.addSubview(self.photosLabel)
        self.contentView.addSubview(self.arrowImage)
        self.contentView.addSubview(self.stackView)
       
        let gallery = MyGallery()
        
        let imageCount = gallery.getCount()
        for i in 1...4 {
            
            let imageView = UIImageView()
            
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 6
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if i > imageCount {
                imageView.image = UIImage(systemName: "photo.on.rectangle.angled")!
                imageView.tintColor = .systemGray6
                imageView.contentMode = .scaleAspectFit
            }
            else {
                imageView.image = gallery.getImage(index: i)
                imageView.contentMode = .scaleAspectFill
            }
            self.stackView.addArrangedSubview(imageView)
            
       }

        NSLayoutConstraint.activate([
            self.photosLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.photosLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            self.photosLabel.heightAnchor.constraint(equalToConstant: 24),
            
            self.arrowImage.centerYAnchor.constraint(equalTo: self.photosLabel.centerYAnchor),
            self.arrowImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.arrowImage.heightAnchor.constraint(equalToConstant: 24),
            self.arrowImage.widthAnchor.constraint(equalToConstant: 24),
            
            self.stackView.topAnchor.constraint(equalTo: self.photosLabel.bottomAnchor, constant: 12),
            self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            self.contentView.heightAnchor.constraint(equalToConstant: 12+24+12+70+12),
        ])
    }
}
