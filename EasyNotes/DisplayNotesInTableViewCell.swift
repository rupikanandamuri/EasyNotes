//
//  DisplayNotesInTableViewCell.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-20.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class DisplayNotesInTableViewCell: UITableViewCell {
    
    @IBOutlet var notesFirstLabel : UILabel!
    @IBOutlet var notesSecondLabel : UILabel!{
        didSet{
            notesSecondLabel.isHidden = true
        }
    }
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var viewBackgroundColor : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
