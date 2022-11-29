//
//  CustomButton.swift
//  Navigation
//
//  Created by Наталья Босякова on 20.11.2022.
//

import UIKit

class CustomButton: UIButton {
    
    var tapAction: () -> Void
    
    init(title: String, backgroundColor: UIColor, tapAction: @escaping () -> Void) {
        
        self.tapAction = tapAction
        
        super.init(frame: .zero)
        
        let config = UIButton.Configuration.gray()
        self.configuration = config
        self.configuration?.title = title
        self.configuration?.baseForegroundColor = .black
        self.configuration?.baseBackgroundColor = backgroundColor
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
