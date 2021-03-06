//
//  ExamTableViewCell.swift
//  myiosapp
//
//  Created by MacBook Pro on 20/10/20.
//

import UIKit


// This class present the Exam item cell design 
class ExamTVC: UITableViewCell {

    @IBOutlet weak var content: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        content.design()
    }

    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var unit: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


}
