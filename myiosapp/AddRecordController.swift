//
//  AddRecordController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit

class AddRecordController: UIViewController {

    @IBOutlet weak var identification: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var givenName: UITextField!
    @IBOutlet weak var dateOfBirth: UIDatePicker!
    
    
    var instanceOfVCA:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func savePersonDetail(_ sender: Any) {
        // get the AppDelegate object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // call function storePersonInfo in AppDelegate
        appDelegate.storePersonInfo(identification: Int(identification.text!)!, surname: surname.text!, givenName: givenName.text!, dateOfBirth: dateOfBirth.date)
        
        let alert = UIAlertController(title: "Alert", message: "Item has added", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
