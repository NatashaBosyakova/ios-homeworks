//
//  LogInViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 18.09.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import RealmSwift

// Собственные домены ошибок. Управление ошибками приложения / задача 1.
enum MyError: Error {
    case invalidPassword
    case invalidLogin
    case emptyData
}

extension MyError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidPassword: return "Your password is invalid. Please try again."
        case .invalidLogin: return "Your login is invalid. Please try again."
        case .emptyData: return "Enter a word and try again."
        }
    }
}

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var stopSearching: Bool = true
    
    var realm = try! Realm()
        
    private /* weak */ var loginDelegate: LoginViewControllerDelegate?

    private var login: String?
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageViewCenter: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.layer.cornerRadius = 10.0
        stackView.layer.borderWidth = 0.5
        stackView.clipsToBounds = true
        stackView.spacing = -1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
   
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.tag = 0
        textField.placeholder = "Login"
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.text = "test@test.com"
        textField.addTarget(self, action:  #selector(textFieldDidChange), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.tag = 1
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.addTarget(self, action:  #selector(textFieldDidChange), for: .editingChanged)

        textField.isSecureTextEntry = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var buttonLogin: UIButton = {
        
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        
        return button
    }()
 
    private lazy var buttonSingUp: UIButton = {
        
        let button = UIButton()
        button.setTitle("Sing Up", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(singUpUser), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonPickUpPassword: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(
            systemName: "sparkle.magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        config.imagePadding = 5
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(startBrutForce), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.loginDelegate = MyLoginFactory().makeLoginInspector()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
                
        super.viewDidLoad()
        
        let currentUserAutorization = realm.object(ofType: CurrentUserAutorization.self, forPrimaryKey: "currentUserAutorization")
        if let autorization = currentUserAutorization {
            loginDelegate!.checkCredentials(login: autorization.login, password: autorization.password) {[weak self] (success, errorDescription) in
                guard let `self` = self else { return }
                
                if (success) {
                    self.showProfileControler()
                } else {
                    self.showLoginControler()
                }
            }
        }
        else {
            self.showLoginControler()
        }
    }
    
    private func saveUserAutorization(login: String, password: String) {
        try! realm.write{
            let userAutorization = CurrentUserAutorization(login: login, password: password)
            realm.add(userAutorization)
        }
    }
 
    private func showLoginControler() {

        self.setupGestures()
        
        #if DEBUG
        self.view.backgroundColor = .white
        #else
        self.view.backgroundColor = .systemGray5
        #endif
        
        addSubviews()
        setConstraints()
        setupIsEnabled()
        
    }
    
    private func addSubviews() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.stackView.addArrangedSubview(self.loginTextField)
        self.stackView.addArrangedSubview(self.passwordTextField)

        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.imageViewCenter)
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.buttonLogin)
        self.scrollView.addSubview(self.buttonSingUp)
        
        self.view.addSubview(self.buttonPickUpPassword)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 340),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.stackView.heightAnchor.constraint(equalToConstant: 100),

            self.buttonLogin.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16),
            self.buttonLogin.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.buttonLogin.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.buttonLogin.heightAnchor.constraint(equalToConstant: 50),
            
            self.buttonSingUp.topAnchor.constraint(equalTo: self.buttonLogin.bottomAnchor, constant: 16),
            self.buttonSingUp.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.buttonSingUp.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.buttonSingUp.heightAnchor.constraint(equalToConstant: 50),

            self.imageViewCenter.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageViewCenter.bottomAnchor.constraint(equalTo: self.stackView.topAnchor),

            self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.imageViewCenter.centerYAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            
            self.buttonPickUpPassword.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor),
            self.buttonPickUpPassword.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupIsEnabled() {
        buttonLogin.isEnabled = loginTextField.text!.isValidEmail() && !passwordTextField.text!.isEmpty
        buttonSingUp.isEnabled = loginTextField.text!.isValidEmail() && !passwordTextField.text!.isEmpty        
        buttonSingUp.alpha = buttonSingUp.isEnabled ? 1.0 : 0.5
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottomPointY = self.buttonSingUp.frame.origin.y + self.buttonSingUp.frame.height
            let keyboardOriginY = self.view.frame.height -
                keyboardHeight -
                self.view.safeAreaInsets.top

            let yOffset = keyboardOriginY < loginButtonBottomPointY
            ? loginButtonBottomPointY - keyboardOriginY + 16
            : 0
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset - self.view.safeAreaInsets.top), animated: true)
       }
    }
 
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
    }
    
    func showProfileControler() {
        let сoordinator = ProfileCoordinator(transitionHandler: navigationController)
        сoordinator.start(user: Auth.auth().currentUser)
    }
    
    @objc func singUpUser(sender: UIButton!) {
        
        loginDelegate!.signUp(login: loginTextField.text!, password: passwordTextField.text!) {[weak self] (success, errorDescription) in
            guard let `self` = self else { return }
        
            if (success) {
                self.showProfileControler()
            } else {
                presentAlert(title: "SignUp Error", message: errorDescription, controller: self)
            }
        }
    }
                         
    @objc func loginUser(sender: UIButton!) {
        
        loginDelegate!.checkCredentials(login: loginTextField.text!, password: passwordTextField.text!) {[weak self] (success, errorDescription) in
            guard let `self` = self else { return }
        
            if (success) {
                self.saveUserAutorization(login: self.loginTextField.text!, password: self.passwordTextField.text!)
                self.showProfileControler()
            } else {
                presentAlert(title: "Login Error", message: errorDescription, controller: self)
            }
        }
        
    }
    
    func checkPasword(login: String, password: String) {
        CheckerService().checkPassword(login: login, password: password) {[weak self] (success, login, password) in
            guard let `self` = self else { return }
        
            if (success) {
                DispatchQueue.main.async {
                    self.passwordTextField.text = password
                    self.passwordTextField.isSecureTextEntry = false
                    self.buttonPickUpPassword.configuration?.title = " success"
                    self.buttonPickUpPassword.configuration?.showsActivityIndicator = false
                }
                
            } else if !self.stopSearching {
                let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
                let newPassword = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                self.checkPasword(login: login, password: newPassword)
            }
        }
    }
    
    @objc private func startBrutForce() {
        
        let login = self.loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (login == "") {
            presentAlert(title: "Enter a login", message: "Enter a login and try again.", controller: self)
        }
        
        else {
            if buttonPickUpPassword.configuration!.showsActivityIndicator {
                buttonPickUpPassword.configuration?.title = ""
                buttonPickUpPassword.configuration?.showsActivityIndicator = false
                stopSearching = true
            }
            else {
                buttonPickUpPassword.configuration?.title = " stop"
                buttonPickUpPassword.configuration?.showsActivityIndicator = true
                
                stopSearching = false
                
                let queue = DispatchQueue.global(qos: .utility)
                queue.async{ [self] in
                    checkPasword(login: login, password: "")
                }
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        setupIsEnabled()
    }
    
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}
