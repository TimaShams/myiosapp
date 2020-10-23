
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

    }
    
    @IBAction func saveExam(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let defaults = UserDefaults.standard
        print("BooleanKey")
        print(defaults.bool(forKey: "id"))

        if(defaults.bool(forKey: "id"))
        {
            defaults.set(defaults.value(forKeyPath: "id") as! Int+1, forKey: "id")
        }
        else
        {
            defaults.set(11111, forKey: "id")
        }
        let ex = MyExam(id: defaults.value(forKeyPath: "id") as! Int, unit: unit.text!, date: date ?? Date(), location: location.text!)

        print(studentVar?.id)
        appDelegate.addExam(exam: ex, student: studentVar!)
        
    }
    

    
}

