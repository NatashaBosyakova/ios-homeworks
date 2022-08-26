//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileHeaderView: ProfileHeaderView = {
        return ProfileHeaderView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray2
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem?.tintColor = .white
                
        view.addSubview(self.profileHeaderView)
        
    }
    
    override func viewWillLayoutSubviews() {
        profileHeaderView.frame = view.frame
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.profileHeaderView.resizeView() // after rotating
        }
        
    }
    
    @objc func showInfoViewController(sender: UIButton!) {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .popover
        self.present(controller, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
