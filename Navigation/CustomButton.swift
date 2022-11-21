//
//  CustomButton.swift
//  Navigation
//
//  Created by Наталья Босякова on 20.11.2022.
//

import UIKit

class CustomButton: UIButton {
    
    var tapAction: ((_: UIButton?) -> Void)!
    
    init(title: String, backgroundColor: UIColor, tapAction: @escaping (_: UIButton?) -> Void) {
        
        super.init(frame: .zero)
        let config = UIButton.Configuration.gray()
        self.configuration = config
        self.configuration?.title = title
        self.configuration?.baseForegroundColor = .white
        self.configuration?.baseBackgroundColor = backgroundColor
        
        self.tapAction = tapAction
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        if (tapAction != nil) {
            self.tapAction(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
