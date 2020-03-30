//
//  HypesViewController.swift
//  Hype
//
//  Created by theevo on 3/30/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
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
        self.hypesTableView.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Get Hype!", message: "What is hype may never die", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "hype message"
            textField.autocorrectionType = .yes
            textField.delegate = self
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let body = alert.textFields?.first?.text,
                !body.isEmpty else { return }
            
            HypeController.shared.saveHype(body: body) { (success) in
                DispatchQueue.main.async {
                    if success {
                        self.updateViews()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formatDate()
        
        return cell
    }
} // end extension


// MARK: - TextField Delegate

extension HypesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
} // end extension
