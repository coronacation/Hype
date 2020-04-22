//
//  LoginViewController.swift
//  Hype
//
//  Created by Theo Vora on 4/6/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var assistLabel: UILabel!
    @IBOutlet weak var assistButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    // MARK: - Helpers
    
    func setUpUI() {
        loginButton.rotate()
        loginButton.setTitleColor(.subtitleGray, for: .normal)
        signupButton.rotate()
        signupButton.setTitleColor(.white, for: .normal)
        emailTextField.addCornerRadius()
        passwordTextField.addCornerRadius()
        confirmPasswordTextField.addCornerRadius()
        emailTextField.addAccentBorder()
        passwordTextField.addAccentBorder()
        confirmPasswordTextField.addAccentBorder()
        actionButton.addCornerRadius()
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        guard let username = emailTextField.text,
            !username.isEmpty else { return }
        
        UserController.shared.createUserWith(username, profilePicture: nil) { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                
                // navigate to Hype VC
                self.presentHypeListVC()
                
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    @IBAction func loginButtonToggleTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.confirmPasswordTextField.isHidden = true
            self.loginButton.setTitleColor(.white, for: .normal)
            self.signupButton.setTitleColor(.subtitleGray, for: .normal)
            self.actionButton.setTitle("Log me in", for: .normal)
            self.assistLabel.text = "Forgot?"
            self.assistButton.setTitle("Remind", for: .normal)
        }
    }
    
    @IBAction func signupButtonToggleTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.confirmPasswordTextField.isHidden = false
            self.loginButton.setTitleColor(.subtitleGray, for: .normal)
            self.signupButton.setTitleColor(.white, for: .normal)
            self.actionButton.setTitle("Sign me up", for: .normal)
            self.assistLabel.text = "Help?"
            self.assistButton.setTitle("FAQ", for: .normal)
        }
    }
    
    
    
    
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
}
