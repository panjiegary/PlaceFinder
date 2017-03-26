//
//  BusinessTableViewCell.swift
//  PlaceFinder
//
//  Created by 潘捷 on 2017-03-22.
//  Copyright © 2017 SMU. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var preview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
