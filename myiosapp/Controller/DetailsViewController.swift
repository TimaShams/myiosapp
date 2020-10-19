//
//  DetailsViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 13/10/20.
//

import UIKit

class DetailsViewController: UIViewController,UIStepperControllerDelegate {

    
    var studentVar: MyStudent? = nil


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
        
        studentVar = MyStudent(id: Int(id.text!)!, fname: fname.text!, lname: lname.text!, gender: tempGender, course: "courses[0]", age: Int(ageSelector.count), lat: 0, long: 0)
    
        appDelegate.storeStudentInfo(student:studentVar!)
        setLabels(student:studentVar!)
        changeDisplay(editView: !false , normalView: !true)
        self.view.layoutIfNeeded()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDisplay(editView: !false , normalView: !true)
        ageSelector.delegate = self
        setLabels(student:studentVar!)
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
        
        id_label.isHidden = normalView
        fname_label.isHidden = normalView
        lname_label.isHidden = normalView
        course_label.isHidden = normalView
        address_label.isHidden = normalView
        gender_label.isHidden = normalView
        age_label.isHidden = normalView
        editButton.isHidden = normalView
        
        
    }

    func stepperDidAddValues(stepper: UIStepperController) {
        print("Stepper value did change (Add) : \(stepper.count)")

    }
    
    func stepperDidSubtractValues(stepper: UIStepperController) {
        print("Stepper value did change (Subtract) \(stepper.count)")

    }
    

}
