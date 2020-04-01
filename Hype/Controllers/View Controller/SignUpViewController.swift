//
//  SignUpViewController.swift
//  Hype
//
//  Created by Theo Vora on 4/1/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! // implicit unwrapping

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserController.shared.createUserWith(username) { (result) in
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
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
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
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }

}
