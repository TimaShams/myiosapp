//
//  DetailsViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 13/10/20.
//

import UIKit
import MapKit
import CoreLocation


extension DetailsViewController: ImageSelected {
    func imageSelected(emoji: String) {
        self.image = emoji
        avatarImage.image = UIImage(named: emoji)
        print("transferred")

    }
    
}

class DetailsViewController: UIViewController,UIStepperControllerDelegate  {
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var map: MKMapView!
    static let notificationName = Notification.Name("edit")

    var lat = 0.0
    var long = 0.0
    var image = ""
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    
    
    var studentVar: MyStudent? = nil

    var address = ""
    
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
    @IBOutlet weak var courseSelector: UIPickerView!
    @IBOutlet weak var course: UITextField!
    
    @IBOutlet weak var imageSelection: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    func setLabels(student:MyStudent){
        
        id_label.text = String(student.id)
        fname_label.text = student.fname
        lname_label.text = student.lname
        course_label.text = student.course
        gender_label.text = student.gender
        age_label.text = String(student.age)
        let userLocation = CLLocationCoordinate2D(latitude: student.lat, longitude: student.long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = student.address
            map.addAnnotation(annotation)
        
        avatarImage.image = UIImage(named: student.image)
        image = student.image
        lat = student.lat
        long = student.long
        address = student.address
    }

    @IBOutlet weak var examButton: UIButton!
    
    @IBAction func showExams(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExamViewController") as! ExamViewController
        
        vc.studentVar = self.studentVar
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func edit(_ sender: Any) {
        changeDisplay(editView: !true , normalView: !false)
        id.text = String(studentVar!.id)
        fname.text = studentVar!.fname
        lname.text = studentVar!.lname
        course.text = studentVar!.course
        ageSelector.count = CGFloat(studentVar!.age)
    }
    

    @IBAction func cancel(_ sender: Any) {
        
        changeDisplay(editView: !false , normalView: !true)
        
    }
    
    
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: "Alert", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func save(_ sender: Any) {

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
        }else if(!appDelegate.isUniqueId(id:Int(id.text!)!)  && (Int(id.text!)! != studentVar?.id)){
            showErrorAlert(msg: "Id is not uniq")
        }
        else
        {
            let tempGender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            appDelegate.deleteSingleStudent(id: studentVar!.id)
            studentVar = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: tempGender, course: course.text!, age : Int(ageSelector.count), lat: lat, long: long ,image: image , address : address )
            appDelegate.insertStudent(student:studentVar!)
            setLabels(student:studentVar!)
            changeDisplay(editView: !false , normalView: !true)
            self.view.layoutIfNeeded()
            showErrorAlert(msg: "Updated")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDisplay(editView: !false , normalView: !true)
        ageSelector.delegate = self
        setLabels(student:studentVar!)

        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: DetailsViewController.notificationName, object: nil)

        

    }
    
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
            annotation.title = dict!["address"] as! String
            annotation.subtitle = "LATER"
            map.addAnnotation(annotation)
        
    }
    
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var changeMap: UIButton!
    
    func changeDisplay(editView:Bool , normalView:Bool){
        
    
        id.isHidden = editView
        fname.isHidden = editView
        lname.isHidden = editView
        course.isHidden = editView
        courseSelector.isHidden = editView
        genderSelector.isHidden = editView
        saveButton.isHidden = editView
        ageSelector.isHidden = editView
        cancelButton.isHidden = editView
        imageSelection.isHidden = editView
        changeMap.isHidden = editView
        
        id_label.isHidden = normalView
        fname_label.isHidden = normalView
        lname_label.isHidden = normalView
        course_label.isHidden = normalView
        gender_label.isHidden = normalView
        age_label.isHidden = normalView
        editButton.isHidden = normalView
        examButton.isHidden = normalView
    }

    func stepperDidAddValues(stepper: UIStepperController) {
        print("Stepper value did change (Add) : \(stepper.count)")

    }
    
    func stepperDidSubtractValues(stepper: UIStepperController) {
        print("Stepper value did change (Subtract) \(stepper.count)")

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getImage" {
            let secondVC: GalleryViewController = segue.destination as! GalleryViewController
            secondVC.delegate = self
        }
    }
    

}
