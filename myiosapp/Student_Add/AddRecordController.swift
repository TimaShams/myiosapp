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
            showErrorAlert(msg: "Id is empty")
        }else if(fname.text == ""){
            showErrorAlert(msg: "First name is empty")
        }else if(lname.text == ""){
            showErrorAlert(msg: "Last name is empty")
        }else if(course.text == ""){
            showErrorAlert(msg: "Course is empty")
        }else if(address == ""){
            showErrorAlert(msg: "address is empty")
        }else if(!appDelegate.isUniqueId(id:Int(id.text!)!)){
            showErrorAlert(msg: "Id is not uniq")
        }else if (lat == 0){
            showErrorAlert(msg: "Select location")
        }
        else
        {
            let gender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            
            let student_ : MyStudent = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: gender, course: course.text!, age: Int(ageSelector.count), lat: lat, long: long , image: imageName , address: address)
            appDelegate.insertStudent(student: student_)
            dismiss(animated: true, completion: nil)
        }
        
        

    }
    
    
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: "Alert", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addImage" {
            let secondVC: GalleryViewController = segue.destination as! GalleryViewController
            secondVC.delegate = self
        }
    }
    
}

extension AddRecordController: ImageSelected {
    func imageSelected(emoji: String) {
        self.imageName = emoji
        avatarImage.image = UIImage(named: emoji)
        print("transferred")

    }
    
}
