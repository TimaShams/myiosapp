//
//  ShowRecordController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit

class ShowRecordController: UIViewController {

    @IBOutlet weak var records: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAllRecords(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //records.text = appDelegate.getPersonInfo()
    }
    
    @IBAction func clearRecords(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.removeAllStudents();

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
