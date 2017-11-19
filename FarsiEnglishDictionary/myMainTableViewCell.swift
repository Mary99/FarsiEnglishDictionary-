//
//  myMainTableViewCell.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-04.
//  Copyright © 2017 veddes. All rights reserved.
//

import UIKit

class myMainTableViewCell: UITableViewCell {
    
    //table View nib has 2 lable for farsi and english display of word
    @IBOutlet weak var farsiLable: UILabel!
    @IBOutlet weak var englishLable: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
