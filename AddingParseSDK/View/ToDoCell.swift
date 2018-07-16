//
//  ToDoCell.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 7/8/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
    @IBOutlet weak var markSongAsReadBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
