//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Наталья Босякова on 24.08.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    // -> extra task
    private var statusText: String = {
        return ""
    }()
    // <- extra task
    
    private let imageSize: CGFloat = {
        return CGFloat(100)
    }()
    
    private lazy var imageView: UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        imageView.image = UIImage(named: "ProfileImage");
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var labelName: UILabel = {
        let labelName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelName.text = "Natasha"
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.textColor = .black
        
        return labelName
    }()
    
    private lazy var labelStatus: UILabel = {
        let labelStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelStatus.text = "learning iOS"
        labelStatus.font = UIFont.systemFont(ofSize: 14)
        labelStatus.textColor = .gray
        
        return labelStatus
    }()
    
    // -> extra task
    private lazy var textStatus: UITextField = {
    
        let textStatus = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textStatus.text = "learning iOS"
        textStatus.font = UIFont.systemFont(ofSize: 15)
        textStatus.textColor = .black
        textStatus.backgroundColor = .white
        textStatus.layer.cornerRadius = 12
        textStatus.layer.borderWidth = 1
        textStatus.layer.borderColor = UIColor.black.cgColor
        textStatus.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 40))
        textStatus.leftViewMode = .always
    
        return textStatus
    }()
    // <- extra task
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 4
        //button.setTitle("Show status", for: .normal)
        button.setTitle("Set status", for: .normal) // extra task
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        
        return button
    }()

    override func draw(_ rect: CGRect) {
        
        button.addTarget(self, action: #selector(showStatus), for: .touchUpInside)
        textStatus.addTarget(self, action: #selector(changeStatus), for: .editingChanged) // extra task
        
        resizeView()
        
        self.addSubview(imageView)
        self.addSubview(labelName)
        self.addSubview(labelStatus)
        self.addSubview(textStatus) // extra task
        self.addSubview(button)

    }
    
    @objc func showStatus() {
        //print("\(labelStatus.text!)")
        labelStatus.text = self.statusText // extra task
    }
    
    // -> extra task
    @objc func changeStatus(_ textField: UITextField) {
        self.statusText = textStatus.text!
    }
    // <- extra task
    
    func resizeView() {
        
        let top: CGFloat = safeAreaInsets.top
        
        imageView.frame = imageView.frame.offsetBy(
            dx: 16 - imageView.frame.origin.x,
            dy: top + 16 - imageView.frame.origin.y)
        
        imageView.frame.size.height = imageSize
        imageView.frame.size.width = imageSize

        labelName.frame = labelName.frame.offsetBy(
            dx: 16 + imageView.frame.width + 16 - labelName.frame.origin.x,
            dy: top + 27 - labelName.frame.origin.y)
        labelName.frame.size.height = 18
        labelName.frame.size.width = frame.width - 16 - imageSize - 6 - 16 - 16
        
        labelStatus.frame = labelStatus.frame.offsetBy(
            dx: 16 + imageView.frame.width + 16 - labelStatus.frame.origin.x,
            dy: imageView.frame.origin.y + imageView.frame.height + 16 - 34 - 14 - labelStatus.frame.origin.y)
        labelStatus.frame.size.height = 14
        labelStatus.frame.size.width = frame.width - 16 - imageSize - 6 - 16 - 16

        // -> extra task
        textStatus.frame = textStatus.frame.offsetBy(
            dx: 16 + imageView.frame.width + 16 - textStatus.frame.origin.x,
            dy: labelStatus.frame.origin.y + labelStatus.frame.height + 8 - textStatus.frame.origin.y)
        textStatus.frame.size.height = 40
        textStatus.frame.size.width = frame.width - 16 - imageSize - 6 - 16 - 16
        // <- extra task
        
        //button.frame = button.frame.offsetBy(
        //    dx: 16 - button.frame.origin.x,
        //    dy: labelStatus.frame.origin.y + labelStatus.frame.height + 34 - button.frame.origin.y)
        //button.frame.size.height = 50
        //button.frame.size.width = frame.width - 16 - 16
                
        // -> extra task
        button.frame = button.frame.offsetBy(
            dx: 16 - button.frame.origin.x,
            dy: textStatus.frame.origin.y + textStatus.frame.height + 16 - button.frame.origin.y)
        button.frame.size.height = 50
        button.frame.size.width = frame.width - 16 - 16
        // <- extra task
        
    }

}
