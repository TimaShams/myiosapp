
import UIKit
import MDatePickerView

protocol BackToList {
  func willReturn()
}




class AddExamVC: UIViewController {
    
    // var
    var delegate: BackToList?
    var studentVar: MyStudent? = nil
    var date: Date? = nil
    
    // IBOutlet
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var location: UITextField!
    
    
    // the apperance of the first view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        content.design()
        
    }

    // Pass the data to the main view controller
    func dataFromContainer(containerData : Date){
      date = containerData
    }
    

    @IBAction func cancel(_ sender: Any) {
        
        self.delegate?.willReturn()
        self.dismiss(animated: true, completion: nil)
        
    }

    
    // Show the alert message based on the caller
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func saveExam(_ sender: Any) {
        
        
        // Show error messages on empty fileds
        if(unit.text == "")
        {
            showErrorAlert(msg: "Unit Name is empty")
            
        }else if (location.text == ""){
            
            showErrorAlert(msg: "Location is empty")
            
        }else
        {

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // Set Exam IDs automatically
            let defaults = UserDefaults.standard

            if(defaults.bool(forKey: "id"))
            {
                defaults.set(defaults.value(forKeyPath: "id") as! Int+1, forKey: "id")
            }
            else
            {
                defaults.set(11111, forKey: "id")
            }
            
            
            // Get the data from the callender view
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: timePicker.date)

            var testdate = Calendar.current.date(bySettingHour: comp.hour!, minute: comp.minute!, second: 0, of: date ?? Date())!

            testdate = Calendar.current.date(byAdding: .day, value: 1, to: testdate)!

            // Create the exam object and add it to the selected student
            let ex = MyExam(id: defaults.value(forKeyPath: "id") as! Int, unit: unit.text!, date: testdate , location: location.text!)

            appDelegate.addExam(exam: ex, student: studentVar!)
            
            // Back to the exam view
            self.delegate?.willReturn()
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
}
