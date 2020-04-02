//
//  HypeTableViewCell.swift
//  Hype
//
//  Created by Theo Vora on 4/2/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

class HypeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var hypeImageView: UIImageView!
    
    
    // MARK: - Properties
    
    var hype: Hype? {
        didSet {
            updateView()
        }
    }

    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: - Helper Functions

    func updateView() {
        guard let hype = hype else { return }
        updateUser(for: hype)
        setPostImage(for: hype)
        captionLabel.text = hype.body
        dateLabel.text = hype.timestamp.formatDate()
    }
    
    func updateUser(for hype: Hype) {
        if hype.user == nil {
            UserController.shared.fetchUserFor(hype) { (result) in
                switch result {
                case .success(let user):
                    hype.user = user
                    self.setUserInfo(for: user)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func setUserInfo(for user: User) {
        DispatchQueue.main.async {
            self.profilePicImageView.image = user.profilePhoto
            self.usernameLabel.text = user.username
        }
    }
    
    func setPostImage(for hype: Hype) {
        if let postImage = hype.hypePhoto {
            hypeImageView.image = postImage
            hypeImageView.isHidden = false
        } else {
            hypeImageView.isHidden = true
        }
    }

}
