//
//  AddRecordController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class AddRecordController: UIViewController {
    
    
    @IBOutlet weak var blur: UIVisualEffectView!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
      {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
      }
    
    
    static let notificationName = Notification.Name("myNotificationName")
    var instanceOfVCA:StudentVC!
    var courses = ["Course 1" , "Course2"]
    var imageName = ""
    var long : Double = 0
    var lat : Double = 0
    var address = ""
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet weak var course: UITextField!
    @IBOutlet var ageSelector: UIStepperController!
    @IBOutlet weak var map: MKMapView!

    
    func onUserAction(data: String ){
        print("Print from add controller")
        print(data)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self

        course.delegate = self
        course.inputView = picker
        blur.isHidden = true
        picker.isHidden = true
        picker.tintColor = UIColor.mybrown
        id.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AddRecordController.notificationName, object: nil)
        
    }
    
    @objc func onNotification(notification:Notification)
    {
        print(notification.userInfo!)
        let dict = notification.userInfo as NSDictionary?
        lat = dict!["lat"] as! Double
        long = dict!["long"] as! Double
        //address.text = dict!["address"] as! String
        self.address = dict!["address"] as! String
        print(address)
        let userLocation = CLLocationCoordinate2D(latitude: lat , longitude: long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = dict!["address"] as! String
            annotation.subtitle = "LATER"
            map.addAnnotation(annotation)
        
        
    }
    
    @IBAction func savePersonDetail(_ sender: Any) {
        // get the AppDelegate object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if(id.text == "")
        {
            showErrorAlert(msg: "ID is empty")
        }else if(fname.text == ""){
            showErrorAlert(msg: "First name is empty")
        }else if(lname.text == ""){
            showErrorAlert(msg: "Last name is empty")
        }else if(course.text == ""){
            showErrorAlert(msg: "Course is empty")
        }else if(address == ""){
            showErrorAlert(msg: "Address is empty")
        }else if(!appDelegate.isUniqueId(id:Int(id.text!)!)){
            showErrorAlert(msg: "ID is not unique")
        }else if (lat == 0){
            showErrorAlert(msg: "Please, select location")
        }
        else
        {
            let gender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            
            let student_ : MyStudent = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: gender, course: course.text!, age: Int(ageSelector.count), lat: lat, long: long , image: imageName , address: address)
            appDelegate.insertStudent(student: student_)
            self.navigationController?.popViewController(animated: true)
        }
        
        

    }
    
    
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addImage" {
            let secondVC: GalleryViewController = segue.destination as! GalleryViewController
            secondVC.delegate = self
        }
    }
    
    let coursList = ["MICT" , "BI" , "Mechanical Engineer"]
    
    @IBOutlet weak var picker: UIPickerView!
}

extension AddRecordController: ImageSelected {
    func imageSelected(emoji: String) {
        self.imageName = emoji
        avatarImage.image = UIImage(named: emoji)
        print("transferred")

    }
    
}


extension AddRecordController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        picker.isHidden = false
        blur.isHidden = false
        return false
    }
}

// MARK: - UIPickerViewDelegate

extension AddRecordController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coursList.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coursList[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        course.text = coursList[row]
        picker.isHidden = true
        blur.isHidden = true
    }
}
