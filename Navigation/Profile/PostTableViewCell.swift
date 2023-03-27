//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Наталья Босякова on 25.09.2022.
//

import UIKit
import StorageService
import iOSIntPackage
import FirebaseAuth

class PostTableViewCell: UITableViewCell {
    
    var post: PostDB?

    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var addToFavoriteButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        config.imagePadding = 5
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    public lazy var deleteFromFavoriteButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(
            systemName: "heart.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        config.imagePadding = 5
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(deleteFromFavorite), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statisticView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
 
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    func setImage(img: UIImage?) -> Void {
        self.postImageView.image = img
    }
    
    @objc private func addToFavorite() {
        CoreDataManager.sharedManager.addPostToFavorite(post: self.post!)
        addToFavoriteButton.isHidden = true
        deleteFromFavoriteButton.isHidden = false
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name("reloadFavorites")))
    }
    
    @objc private func deleteFromFavorite() {
        CoreDataManager.sharedManager.deletePostFromFavorite(post: self.post!)
        addToFavoriteButton.isHidden = false
        deleteFromFavoriteButton.isHidden = true
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name("reloadFavorites")))
    }
    
    func setup(post: PostDB, isFavorite: Bool) {
        
        let uiImage = UIImage(data: post.imageData!)!
        
        ImageProcessor().processImage(sourceImage: uiImage, filter: .sepia(intensity: 0.2), completion: setImage)
        
        self.post = post
        self.authorLabel.text = post.author
        self.descriptionLabel.text = post.postDescription
        self.likesLabel.text = "Likes: "+String(post.likes)
        self.viewsLabel.text = "Views: "+String(post.views)
        
        self.addToFavoriteButton.isHidden = isFavorite
        self.deleteFromFavoriteButton.isHidden = !isFavorite
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addToFavorite))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImageView.image = nil
        self.authorLabel.text = nil
        self.descriptionLabel.text = nil
        self.likesLabel.text = nil
        self.viewsLabel.text = nil
    }
    
    private func setupView() {
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.addToFavoriteButton)
        self.contentView.addSubview(self.deleteFromFavoriteButton)
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.descriptionLabel)
        self.statisticView.addSubview(self.likesLabel)
        self.statisticView.addSubview(self.viewsLabel)
        self.contentView.addSubview(self.statisticView)

        NSLayoutConstraint.activate([
            
            self.authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.authorLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.authorLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16-32),

            self.addToFavoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.addToFavoriteButton.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16-32),
            self.addToFavoriteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.deleteFromFavoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.deleteFromFavoriteButton.leftAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16-32),
            self.deleteFromFavoriteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),

            self.postImageView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 12),
            self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.postImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1.0),

            self.descriptionLabel.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 16),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.likesLabel.topAnchor.constraint(equalTo: self.statisticView.topAnchor),
            self.likesLabel.leftAnchor.constraint(equalTo: self.statisticView.leftAnchor),
            self.likesLabel.rightAnchor.constraint(equalTo: self.statisticView.centerXAnchor),
            self.likesLabel.bottomAnchor.constraint(equalTo: self.statisticView.bottomAnchor),

            self.viewsLabel.topAnchor.constraint(equalTo: self.statisticView.topAnchor),
            self.viewsLabel.leftAnchor.constraint(equalTo: self.statisticView.centerXAnchor),
            self.viewsLabel.rightAnchor.constraint(equalTo: self.statisticView.rightAnchor),
            self.viewsLabel.bottomAnchor.constraint(equalTo: self.statisticView.bottomAnchor),
        
            self.statisticView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.statisticView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.statisticView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.statisticView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),

        ])
    }

}
