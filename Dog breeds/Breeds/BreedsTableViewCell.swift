//
//  BreedsTableViewCell.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class BreedsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countSubbreedsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
