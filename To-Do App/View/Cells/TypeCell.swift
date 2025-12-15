//
//  TypeCell.swift
//  To-Do App
//
//  Created by Костя Кодолов on 15.12.2025.
//

import UIKit

class TypeCell: UITableViewCell {
    
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var typeDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
