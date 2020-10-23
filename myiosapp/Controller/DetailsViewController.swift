//
//  DetailsViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 13/10/20.
//

import UIKit
import MapKit
import CoreLocation


extension DetailsViewController: BacktoAdd {
  func returnLocation(lat_ : Double  , long_ : Double) {
    self.lat = lat_
    self.long = long_
    print("ddddd")
  }
}

extension DetailsViewController: ImageSelected {
    func imageSelected(emoji: String) {
        self.image = emoji
        avatarImage.image = UIImage(named: emoji)
        print("transferred")

    }
    
}

class DetailsViewController: UIViewController,UIStepperControllerDelegate  {
    
    @IBOutlet weak var container: UIView!
    
    static let notificationName = Notification.Name("edit")

    var lat = 0.0
    var long = 0.0
    var image = ""
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    
    
    var studentVar: MyStudent? = nil

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var id_label: UILabel!
    @IBOutlet weak var fname_label: UILabel!
    @IBOutlet weak var lname_label: UILabel!
    @IBOutlet weak var course_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var gender_label: UILabel!
    @IBOutlet weak var age_label: UILabel!

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet weak var address: UITextField!
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
        address_label.text = String(student.lat)
        gender_label.text = student.gender
        age_label.text = String(student.age)
        let userLocation = CLLocationCoordinate2D(latitude: student.lat, longitude: student.long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation
            annotation.title = student.fname
            annotation.subtitle = "LATER"
            map.addAnnotation(annotation)
        
        avatarImage.image = UIImage(named: student.image)
    }
    
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
        //GENDER
        ageSelector.count = CGFloat(studentVar!.age)
        address.text = String(studentVar!.lat)
    }
    

    @IBAction func cancel(_ sender: Any) {
        
        changeDisplay(editView: !false , normalView: !true)
        
    }
    
    @IBAction func save(_ sender: Any) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let tempGender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
        
        appDelegate.deleteSingleStudent(id: studentVar!.id)
        
        studentVar = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: tempGender, course: "courses[0]", age: Int(ageSelector.count), lat: lat, long: long ,image: image )
    
        appDelegate.insertStudent(student:studentVar!)
        setLabels(student:studentVar!)
        changeDisplay(editView: !false , normalView: !true)
        self.view.layoutIfNeeded()

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
    }
    
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    func changeDisplay(editView:Bool , normalView:Bool){
        
    
        id.isHidden = editView
        fname.isHidden = editView
        lname.isHidden = editView
        course.isHidden = editView
        courseSelector.isHidden = editView
        address.isHidden = editView
        genderSelector.isHidden = editView
        saveButton.isHidden = editView
        ageSelector.isHidden = editView
        cancelButton.isHidden = editView
        container.isHidden = editView
        imageSelection.isHidden = editView
        
        id_label.isHidden = normalView
        fname_label.isHidden = normalView
        lname_label.isHidden = normalView
        course_label.isHidden = normalView
        address_label.isHidden = normalView
        gender_label.isHidden = normalView
        age_label.isHidden = normalView
        editButton.isHidden = normalView
        map.isHidden = normalView
        
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
