//
//  AddRecordController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit

class AddRecordController: UIViewController {

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet weak var course: UITextField!
    @IBOutlet var ageSelector: UIStepperController!
    @IBOutlet weak var address: UITextField!
    
    var instanceOfVCA:ViewController!
    var courses = ["Course 1" , "Course2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func savePersonDetail(_ sender: Any) {
        // get the AppDelegate object

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // call function storePersonInfo in AppDelegate
        let gender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
        
        let student_ : MyStudent = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: gender, course: courses[0], age: Int(ageSelector.count), lat: 0, long: 0)
        
        
        appDelegate.storeStudentInfo(student: student_)
       
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
