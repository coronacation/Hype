//
//  CreatePostViewController.swift
//  Hype
//
//  Created by Theo Vora on 4/2/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    
    
    // MARK: - Properties
    var image: UIImage?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        guard let text = titleTextField.text,
            !text.isEmpty,
            let image = self.image else { return }
        
        HypeController.shared.saveHype(body: text, photo: image) { (result) in
            guard let _ = try? result.get() else { return }
            self.dismissView()
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPickerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }

}

extension CreatePostViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}
