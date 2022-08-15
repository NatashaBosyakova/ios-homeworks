//
//  ViewController.swift
//  Netology_IB_Instruments
//
//  Created by Наталья Босякова on 14.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        loadFromXib()
    }

    func loadFromXib() {
        view.backgroundColor = .yellow
        
        let xibView = Bundle.main.loadNibNamed("ProfileView", owner: nil, options: nil)?.first as? ProfileView
        
        if xibView != nil {
            
            view.backgroundColor = .gray
            
            xibView!.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 300)
            
            view.backgroundColor = .systemBlue
            
            view.addSubview(xibView!)
        }
    }
    
}

