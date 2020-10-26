//
//  TableViewCell.swift
//  myiosapp
//
//  Created by MacBook Pro on 12/10/20.
//

import UIKit

class StudentTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.design()
    }
    
    // This code prsent the table view cell 
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


}

