//
//  TeaTableViewCell.swift
//  TSpooon
//
//  Created by Jacob Pyke on 23.01.19.
//  Copyright © 2019 Pykee Co. All rights reserved.
//

import UIKit

class TeaTableViewCell: UITableViewCell {
    // Mark: Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
