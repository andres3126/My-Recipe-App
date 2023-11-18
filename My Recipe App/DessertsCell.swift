//
//  DessertsCell.swift
//  My Recipe App
//
//  Created by Andres Duque Valencia on 15/11/23.
//

import UIKit

class DessertsCell: UITableViewCell {

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var dessertView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
