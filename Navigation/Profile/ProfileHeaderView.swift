//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Наталья Босякова on 24.08.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = {
        return "learning iOS"
    }()
    
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var labelName: UILabel = {
        let labelName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelName.text = "Natasha"
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false

        return labelName
    }()
    
    private lazy var labelStatus: UILabel = {
        let labelStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelStatus.text = "learning iOS"
        labelStatus.font = UIFont.systemFont(ofSize: 14)
        labelStatus.textColor = .gray
        labelStatus.translatesAutoresizingMaskIntoConstraints = false

        return labelStatus
    }()
    
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
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        textStatus.addTarget(self, action: #selector(changeStatus), for: .editingChanged) // extra task

        return textStatus
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.layer.cornerRadius = 4
        button.setTitle("Set status", for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStatus), for: .touchUpInside)

        return button
    }()
    
    override func draw(_ rect: CGRect) {
                
        self.addSubview(imageView)
        self.addSubview(labelName)
        self.addSubview(labelStatus)
        self.addSubview(textStatus)
        self.addSubview(button)
        resizeView()
        
    }
    
    @objc func showStatus() {
        labelStatus.text = self.statusText
    }
    
    @objc func changeStatus(_ textField: UITextField) {
        self.statusText = textStatus.text!
    }
    
    func resizeView() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
       ])
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            labelName.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            labelName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            labelName.heightAnchor.constraint(equalToConstant: 18),
       ])
        
        NSLayoutConstraint.activate([
            labelStatus.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -28),
            labelStatus.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            labelStatus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            labelStatus.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        NSLayoutConstraint.activate([
            textStatus.topAnchor.constraint(equalTo: labelStatus.bottomAnchor, constant: 8),
            textStatus.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            textStatus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            textStatus.heightAnchor.constraint(equalToConstant: 40),
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textStatus.bottomAnchor, constant: 16),
            button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }

}
