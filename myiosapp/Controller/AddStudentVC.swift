

import UIKit
import MapKit
import CoreLocation
class AddStudentVC: UIViewController {
    
    

    
    // IBOutlet
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet weak var course: UITextField!
    @IBOutlet var ageSelector: UIStepperController!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    // IBOutlet
    static let notificationName = Notification.Name("myNotificationName")
    
    // var
    var instanceOfVCA:StudentVC!
    var courses = ["Course 1" , "Course2"]
    var imageName = ""
    var long : Double = 0
    var lat : Double = 0
    var address = ""
    
    

    
    

    // The fist view of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        id.delegate = self
        phone.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: AddStudentVC.notificationName, object: nil)
        self.view.setGradientBackground(colorTop: UIColor.mygreen , colorBottom: UIColor.myyellow)
        bg1.design()
        bg2.design()
        saveButton.design()
        ageSelector.count = 20
        ageSelector.borderColor(color: UIColor.mygreen)
        ageSelector.textColor(color: .black)

    }
    
    // Get the data from the map view
    func onUserAction(data: String ){
        print(data)
    }
    
    // Get the lat and long from the map view based on user selection
    @objc func onNotification(notification:Notification)
    {
        
        // Retreive the data
        let dict = notification.userInfo as NSDictionary?
        lat = dict!["lat"] as! Double
        long = dict!["long"] as! Double
        self.address = dict!["address"] as! String
        let userLocation = CLLocationCoordinate2D(latitude: lat , longitude: long)
        map.setCenter(userLocation, animated: true)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(viewRegion, animated: false)
        
        // Set the map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation
        annotation.title = dict!["address"] as! String
        annotation.subtitle = "LATER"
        map.addAnnotation(annotation)
    }
    
    // Save the input detail in the core data
    @IBAction func savePersonDetail(_ sender: Any) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Validate the input information
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
            
            // insert to the core data
            let gender: String = (genderSelector.selectedSegmentIndex == 0) ? "Male" : "Female"
            let student_ : MyStudent = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: gender, course: course.text!, age: Int(ageSelector.count), lat: lat, long: long , image: imageName , address: address , phone : Int(phone.text!)!)
            
            appDelegate.insertStudent(student: student_)
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    // Show alerts based on the user error
    func showErrorAlert(msg : String ){
        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Segue to gallery image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addImage" {
            let secondVC: GalleryVC = segue.destination as! GalleryVC
            secondVC.delegate = self
        }
    }
    
}


extension AddStudentVC : UITextFieldDelegate {

    // accept only numbers for the texEdit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}



extension AddStudentVC: ImageSelected {
    
    // Return the selected image value from the gallery view
    func imageSelected(emoji: String) {
        self.imageName = emoji
        avatarImage.image = UIImage(named: emoji)
        
    }
    
}

