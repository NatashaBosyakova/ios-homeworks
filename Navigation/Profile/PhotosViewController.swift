//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 05.10.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
        
    var gallery: [UIImage] = []
    var imagePublisher = ImagePublisherFacade()
    var executionTime: Double = 0
    
    private enum Constants {
        static let numberOfItemsInLine: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateGallery(array: [CGImage?]) -> Void {
        
        executionTime = CFAbsoluteTimeGetCurrent() - executionTime
        print("Execution time: \(executionTime) seconds.")
        
        for img in array {
            self.gallery.append(UIImage(cgImage: img!))
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        
        executionTime = CFAbsoluteTimeGetCurrent()
        ImageProcessor().processImagesOnThread(
            sourceImages: MyGallery().getImages(),
            filter: .chrome,
            qos: .default,
            completion: updateGallery)
        
        // userInteractive (33) - 13 изображений, Execution time: 6.431676983833313 seconds.
        // userInteractive (33) - 26 изображений, Execution time: 13.44985294342041 seconds.

        // userInitiated (25) - 13 изображений, Execution time: 7.248588919639587 seconds.
        // userInitiated (25) - 26 изображений, Execution time: 10.32836103439331 seconds.

        // utility (17) - 13 изображений, Execution time: 22.689758896827698 seconds.
        // utility (17) - 26 изображений, Execution time: 43.60951101779938 seconds.

        // background (9) - 13 изображений, Execution time: 67.60066306591034 seconds.
        
        // default (-1) - 13 изображений, Execution time: 5.55302894115448 seconds.
        
        //imagePublisher.subscribe(self)
        //imagePublisher.addImagesWithTimer(time: 0.5, repeat: 20, userImages: MyGallery().getImages())
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagePublisher.removeSubscription(for: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Photo Gallery"
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? PhotosCollectionViewCell
 
        cell!.clipsToBounds = true
        cell!.setup(with: self.gallery[indexPath.row])
       return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0

        let width = collectionView.frame.width - (Constants.numberOfItemsInLine - 1) * interItemSpacing - insets.left - insets.right
        let itemWidth = floor(width / Constants.numberOfItemsInLine)

        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    
    func receive(images: [UIImage]) {
        gallery = images
        collectionView.reloadData()
    }
}
