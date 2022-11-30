//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Наталья Босякова on 24.08.2022.
//

import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    private var statusText: String = {
        return ""
    }()
    
    private let imageSize: CGFloat = {
        return CGFloat(100)
    }()
    
    public lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView

    }()
    
    private lazy var labelName: UILabel = {
        let labelName = UILabel()
        labelName.text = "Natasha"
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false

        return labelName
    }()
    
    private lazy var labelStatus: UILabel = {
        let labelStatus = UILabel()
        labelStatus.text = "learning iOS"
        labelStatus.font = UIFont.systemFont(ofSize: 14)
        labelStatus.textColor = .gray
        labelStatus.translatesAutoresizingMaskIntoConstraints = false

        return labelStatus
    }()
    
    private lazy var textStatus: UITextField = {
    
        let textStatus = UITextField()
        textStatus.placeholder = "learning iOS"
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
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.setTitle("Set status", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStatus), for: .touchUpInside)

        return button
    }()
    
    func setUserData(user: User) {
        labelStatus.text = user.status
        imageView.image = user.avatar
        labelName.text = user.fullName
        textStatus.placeholder = user.status
   }
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
                
        self.addSubview(imageView)
        self.addSubview(labelName)
        self.addSubview(labelStatus)
        self.addSubview(textStatus)
        self.addSubview(button)
        
        resizeView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showStatus() {
        
        guard self.statusText != "fail" else { // Собственные домены ошибок. Управление ошибками приложения / задача 4.
            preconditionFailure("test preconditionFailure")
        }
        
        labelStatus.text = self.statusText
    }
    
    @objc func changeStatus(_ textField: UITextField) {
        self.statusText = textStatus.text!
    }

    @objc func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    
    func resizeView() {
   
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(imageSize)
        }
        
        labelName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.left.equalTo(imageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
        
        labelStatus.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-28)
            make.left.equalTo(imageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(14)
        }
        
        textStatus.snp.makeConstraints { make in
            make.top.equalTo(labelStatus.snp.bottom).offset(8)
            make.left.equalTo(imageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textStatus.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
    }

}
