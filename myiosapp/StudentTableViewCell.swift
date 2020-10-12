//
//  TableViewCell.swift
//  myiosapp
//
//  Created by MacBook Pro on 12/10/20.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genderAge: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
