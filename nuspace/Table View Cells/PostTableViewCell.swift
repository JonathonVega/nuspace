//
//  PostTableViewCell.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/17/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var userProfileImage: UIImage?
    var name: UILabel?
    var username: UILabel?
    var postMessage: UILabel?
    var postImage: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
