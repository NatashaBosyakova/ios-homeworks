//
//  FeedViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

struct Post0 {
    var text: String
}

class FeedViewController: UIViewController {
    
    var post: Post0
    
    private lazy var button1: CustomButton = {
                
        let button = CustomButton(
            title: "Show post 1",
            backgroundColor: UIColor(named: "ButtonColor")!,
            tapAction: showPostViewController)

        return button
        
    }()
 
    private lazy var button2: CustomButton = {
        
        let button = CustomButton(
            title: "Show post 2",
            backgroundColor: UIColor(named: "ButtonColor")!,
            tapAction: showPostViewController)

        return button
        
    }()
    
    private lazy var wordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your word"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .gray
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.black.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        textField.leftViewMode = .always
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        textField.rightViewMode = .always

        return textField
    }()
   
    private lazy var checkGuessLabel: UILabel = {
        
        let label = UILabel()
        label.text = " "
        label.textColor = .white
        label.backgroundColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private lazy var tipLabel: UILabel = {
        
        let label = UILabel()
        label.text = "*The best choice: Snail"
        label.textColor = .white
        return label
        
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        
        let button = CustomButton(
            title: "Check word",
            backgroundColor: UIColor(named: "ButtonColor")!,
            tapAction: checkWord)

        return button
        
    }()
   
    private lazy var stackViewGuessWord: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing

        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing

        return stackView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.post = Post0(text: "Some post (title from FeedViewController)")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemGray3

        addSubviews()
        setConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(stackViewGuessWord)
        stackView.addArrangedSubview(tipLabel)

        stackViewGuessWord.addArrangedSubview(wordField)
        stackViewGuessWord.addArrangedSubview(checkGuessLabel)
        stackViewGuessWord.addArrangedSubview(checkGuessButton)
        
        view.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkGuessLabel.heightAnchor.constraint(equalToConstant: 20),
            checkGuessLabel.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc func showPostViewController(sender: UIButton!) {
        let controller = PostViewController()
        controller.post = self.post
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showInfoViewController(sender: UIButton!) {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .popover
        self.present(controller, animated: true)
    }
    
    @objc func checkWord(sender: UIButton!) {
        
        let word = wordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if word != "" {
            
            let feedModel = FeedModel()
                
            checkGuessLabel.backgroundColor = feedModel.check(word) ? .green : .red
            checkGuessLabel.text = feedModel.check(word) ? "✓" : "-"
            checkGuessLabel.textColor = .white
            
            let alert = UIAlertController(
                title: feedModel.check(word) ? "Right" : "Wrong",
                message: feedModel.check(word) ? "Cool" : "Try again.",
                preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            alert.view.tintColor = .black
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else {
            
            checkGuessLabel.text = " "
            checkGuessLabel.backgroundColor  = .gray
            
            let alert = UIAlertController(
                title: "Enter a word",
                message: "Enter a word and try again.",
                preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            alert.view.tintColor = .black
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
