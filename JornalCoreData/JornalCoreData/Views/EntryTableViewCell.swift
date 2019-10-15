//
//  EntryTableViewCell.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var journalTitleName: UILabel!
    @IBOutlet weak var journalBodyText: UILabel!
    @IBOutlet weak var timeStampjournal: UILabel!
    
// add didSet property observer to entry variable call updateviews in it. 
    
    var entry: Entry? { didSet {updateViews() }}
    
//     create updateViews that takes the values from the Entry variable and places them in the outlets

    func updateViews() {
        guard let entry = entry else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yy, hh:mm a"
        journalTitleName.text = entry.title
        journalBodyText.text = entry.bodyText
        timeStampjournal.text = formatter.string(from: entry.timestamp ?? Date())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
