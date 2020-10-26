//
//  DetailsViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 13/10/20.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI



class StudentDetailVC: UIViewController, UIStepperControllerDelegate  {
    
    

    // var
    var lat = 0.0
    var long = 0.0
    var image = ""
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var anot : MKPointAnnotation = MKPointAnnotation()
    var studentVar: MyStudent? = nil
    var address = ""
    
    // let
    let coursList = ["MICT" , "BI" , "Mechanical Engineer"]
    static let notificationName = Notification.Name("edit")

    // IBOutlet items in the view
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var phone_label: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var id_label: UILabel!
    @IBOutlet weak var fname_label: UILabel!
    @IBOutlet weak var lname_label: UILabel!
    @IBOutlet weak var course_label: UILabel!
    @IBOutlet weak var gender_label: UILabel!
    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet var ageSelector: UIStepperController!
    @IBOutlet weak var course: UITextField!
    @IBOutlet weak var imageSelection: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var examButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeMap: UIButton!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg2: UIView!
    
    
    
    // prpeare the view for the first apperance
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDisplay(editView: !false , normalView: !true)
        ageSelector.delegate = self
        setLabels(student:studentVar!)

        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: StudentDetailVC.notificationName, object: nil)

        // set navigation bar title
        self.navigationItem.title = (studentVar?.fname)!+" "+(studentVar?.lname)!
        
        // design the buttons and bachgrounds
        bg1.design()
        bg2.design()
        examButton.design()
        self.view.setGradientBackground(colorTop: UIColor.myyellow , colorBottom: UIColor.myorange)
        ageSelector.borderColor(color: UIColor.mygreen)
        ageSelector.textColor(color: .black)
    }
    
    
    func setLabels(student:MyStudent){
        
        // Set the labels values in the view based on the given studenat details
        id_label.text = String(student.id)
        fname_label.text = student.fname
        lname_label.text = student.lname
        course_label.text = student.course
        gender_label.text = student.gender
        age_label.text = String(student.age)
        phone_label.text = "0"+String(student.phone)
        
        // Set the user location on the map based on the student given
        let userLocation = CLLocationCoordinate2D(latitude: student.lat, longitude: student.long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        // Set annotation
        let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = student.address
            map.addAnnotation(annotation)
        anot = annotation
        avatarImage.image = UIImage(named: student.image)
        image = student.image
        lat = student.lat
        long = student.long
        address = student.address
    }

    
    // /navigate to the student exams list
    @IBAction func showExams(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExamViewController") as! ExamVC
        vc.studentVar = self.studentVar
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Allow the edit the student information
    @IBAction func edit(_ sender: Any) {
        changeDisplay(editView: !true , normalView: !false)
        id.text = String(studentVar!.id)
        fname.text = studentVar!.fname
        lname.text = studentVar!.lname
        course.text = studentVar!.course
        ageSelector.count = CGFloat(studentVar!.age)
        phone.text = "0"+String(studentVar!.phone)
    }
    
    // Can the edit
    @IBAction func cancel(_ sender: Any) {
        changeDisplay(editView: !false , normalView: !true)
    }



    // Show allert based on the given message
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: nil, message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    // Save all data given by the user for the student
    @IBAction func save(_ sender: Any) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Show msgs based on the problem accoured
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
        }else if(!appDelegate.isUniqueId(id:Int(id.text!)!)  && (Int(id.text!)! != studentVar?.id)){
            showErrorAlert(msg: "ID is not unique")
        }else if(phone.text=="")
        {
            showErrorAlert(msg: "Phone is empty")
        }
        else
        {
            // if all fields are not empty, update the new value of the user
            
            let tempGender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            appDelegate.deleteSingleStudent(id: studentVar!.id)
            studentVar = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: tempGender, course: course.text!, age : Int(ageSelector.count), lat: lat, long: long ,image: image , address : address, phone: Int(phone.text!)! )
            appDelegate.insertStudent(student:studentVar!)
            setLabels(student:studentVar!)
            changeDisplay(editView: !false , normalView: !true)
            self.view.layoutIfNeeded()
            showErrorAlert(msg: "Updated")
            self.navigationItem.title = (studentVar?.fname)!+" "+(studentVar?.lname)!
            
        }

    }
    
    
    // Get the values from the map view for the user information 
    @objc func onNotification(notification:Notification)
    {
        print(notification.userInfo!)
        let dict = notification.userInfo as NSDictionary?
        lat = dict!["lat"] as! Double
        long = dict!["long"] as! Double
        address = dict!["address"] as! String
        
        let userLocation = CLLocationCoordinate2D(latitude: lat , longitude: long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = (dict!["address"] as! String)
            map.addAnnotation(annotation)
    }
    
    
 
    
    // Change the display items based on the view based on the given value in each view
    func changeDisplay(editView:Bool , normalView:Bool){
        
     
        
        id.isHidden = editView
        fname.isHidden = editView
        lname.isHidden = editView
        course.isHidden = editView
        genderSelector.isHidden = editView
        saveButton.isHidden = editView
        ageSelector.isHidden = editView
        cancelButton.isHidden = editView
        imageSelection.isHidden = editView
        changeMap.isHidden = editView
        phone.isHidden = editView
        
        
        id_label.isHidden = normalView
        fname_label.isHidden = normalView
        lname_label.isHidden = normalView
        course_label.isHidden = normalView
        gender_label.isHidden = normalView
        age_label.isHidden = normalView
        editButton.isHidden = normalView
        examButton.isHidden = normalView
        phone_label.isHidden = normalView
    }

    // Stepper delegate functions for add
    func stepperDidAddValues(stepper: UIStepperController) {
        print("Stepper value did change (Add) : \(stepper.count)")

    }
    // Stepper delegate functions for substract
    func stepperDidSubtractValues(stepper: UIStepperController) {
        print("Stepper value did change (Subtract) \(stepper.count)")

    }
    
    // Go the the gallery view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getImage" {
            let secondVC: GalleryVC = segue.destination as! GalleryVC
            secondVC.delegate = self
        }
    }
    

    

}

// Get the selected image ID 
extension StudentDetailVC: ImageSelected {
    func imageSelected(emoji: String) {
        self.image = emoji
        avatarImage.image = UIImage(named: emoji)
    }
    
}
