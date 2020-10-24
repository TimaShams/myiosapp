
import UIKit
import MDatePickerView

protocol BackToList {
  func willReturn()
}



class AddExamViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: BackToList?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    @IBOutlet weak var content: UIView!
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    var studentVar: MyStudent? = nil

    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var unit: UITextField!

    @IBOutlet weak var location: UITextField!
    
    
    func dataFromContainer(containerData : Date){
     //print(containerData)
     date = containerData
    }
    


    var date: Date? = nil
    
    @IBAction func cancel(_ sender: Any) {
        
        self.delegate?.willReturn()
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        content.design()
        
    }
    
    func showErrorAlert(msg : String ){
        
        let alert = UIAlertController(title: "", message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func saveExam(_ sender: Any) {
        
        
        if(unit.text == "")
        {
            showErrorAlert(msg: "Unit Name is empty")
            
        }else if (location.text == ""){
            
            showErrorAlert(msg: "Location is empty")
            
        }else
        {
            
            
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let defaults = UserDefaults.standard

            if(defaults.bool(forKey: "id"))
            {
                defaults.set(defaults.value(forKeyPath: "id") as! Int+1, forKey: "id")
            }
            else
            {
                defaults.set(11111, forKey: "id")
            }
            
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: timePicker.date)

            var testdate = Calendar.current.date(bySettingHour: comp.hour!, minute: comp.minute!, second: 0, of: date ?? Date())!

            testdate = Calendar.current.date(byAdding: .day, value: 1, to: testdate)!

            
            let ex = MyExam(id: defaults.value(forKeyPath: "id") as! Int, unit: unit.text!, date: testdate , location: location.text!)

            appDelegate.addExam(exam: ex, student: studentVar!)
            self.delegate?.willReturn()
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    

    
}


