//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Наталья Босякова on 05.10.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with image: UIImage) {
        self.imageView.image = image
    }
    
    private func setupView() {
        self.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
}
