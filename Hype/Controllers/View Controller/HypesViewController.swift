//
//  HypesViewController.swift
//  Hype
//
//  Created by Theo Vora on 3/30/20.
//  Copyright © 2020 Studio Awaken. All rights reserved.
//

import UIKit

class HypesViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var hypesTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHypes()
        setupViews()
    }
    
    
    // MARK: - Custom Methods
    
    func setupViews() {
        self.hypesTableView.delegate = self
        self.hypesTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        refreshControl.addTarget(self, action: #selector(loadHypes), for: .valueChanged)
        hypesTableView.addSubview(refreshControl)
    }
    
    @objc func loadHypes() {
        HypeController.shared.fetchAllHypes { (success) in
            DispatchQueue.main.async {
                if success {
                    self.updateViews()
                }
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.hypesTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        presentAddHypeAlert(for: nil)
    }
    
    
    // MARK: - Helpers
    
    func presentAddHypeAlert(for hype: Hype? = nil) {
        
        let alert = UIAlertController(title: "Get Hype!", message: "What is hype may never die", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = "What is hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let hype = hype {
                textField.text = hype.body
            }
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let body = alert.textFields?.first?.text,
                !body.isEmpty else { return }
            
            if let hype = hype {
                hype.body = body
                HypeController.shared.update(hype) { (success) in
                    if success {
                        self.updateViews()
                    }
                    
                    
                }
            } else {
                
                // we already have the photo saved in photo data so we don't need to resave
                
                HypeController.shared.saveHype(body: body, photo: nil) { (result) in
                    switch result{
                    case .success(_):
                        DispatchQueue.main.async {
                            self.updateViews()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        alert.addAction(saveButton)
        
        let cancelButton = UIAlertAction(title: "nvm", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    
    
} // end class


extension HypesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath) as? HypeTableViewCell else { return UITableViewCell() }
        
        let hype = HypeController.shared.hypes[indexPath.row]
        cell.hype = hype
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hype = HypeController.shared.hypes[indexPath.row]
        presentAddHypeAlert(for: hype)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let hype = HypeController.shared.hypes[indexPath.row]
            guard let index = HypeController.shared.hypes.firstIndex(of: hype) else { return }
            HypeController.shared.delete(hype) { (success) in
                if success {
                    HypeController.shared.hypes.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    } // end editingStyle
    
    
} // end extension


// MARK: - TextField Delegate

extension HypesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} // end extension
