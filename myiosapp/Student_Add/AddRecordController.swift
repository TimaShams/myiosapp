//
//  AddRecordController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit


extension AddRecordController: BacktoAdd {
  func returnLocation(lat_ : Double  , long_ : Double) {
    self.lat = lat_
    self.long = long_
    print("ddddd")
  }
}

class AddRecordController: UIViewController {
    
    static let notificationName = Notification.Name("myNotificationName")


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
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AddRecordController.notificationName, object: nil)
        
    }
    
    @objc func onNotification(notification:Notification)
    {
        print(notification.userInfo!)
        let dict = notification.userInfo as NSDictionary?
        lat = dict!["lat"] as! Double
        long = dict!["long"] as! Double
    }

    var long : Double = 0
    var lat : Double = 0

    
    func onUserAction(data: String)
    {
        print("Data received: \(data)")
    }
    
    
    @IBAction func savePersonDetail(_ sender: Any) {
        // get the AppDelegate object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        print(lat)
        if(id.text == "")
        {
            let alert = UIAlertController(title: "Alert", message: "Id is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(fname.text == ""){
            
            let alert = UIAlertController(title: "Alert", message: "First name is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if(lname.text == ""){
            
            let alert = UIAlertController(title: "Alert", message: "Last name is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if(course.text == ""){
            
            
            let alert = UIAlertController(title: "Alert", message: "Course is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if(address.text == ""){
            
            
            let alert = UIAlertController(title: "Alert", message: "address is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }else if(!appDelegate.isUniqueId(id:Int(id.text!)!))
        {
            
            let alert = UIAlertController(title: "Alert", message: "Id is not uniq", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if (lat == 0)
        {
            
            let alert = UIAlertController(title: "Alert", message: "Select location", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else
        {
            
            let gender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            
            let student_ : MyStudent = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: gender, course: courses[0], age: Int(ageSelector.count), lat: lat, long: long , image: "f1")    
            appDelegate.insertStudent(student: student_)
            
        }

    }

}
