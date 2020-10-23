
import UIKit
import DateTimePicker

extension ExamViewController: BackToList {
  func willReturn() {
    self.getMyInfo()
  }
}

class ExamViewController: UIViewController {
    

    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var examStatus: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
    var picker: DateTimePicker?
    var pastExams : [MyExam] = []
    var futureExams : [MyExam] = []
    var studentVar: MyStudent? = nil
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableview.allowsMultipleSelection = true
        self.getMyInfo()
        examStatus.addTarget(self, action: #selector(self.indexChanged(_:)), for: .valueChanged)

    }
    
    
    func getMyInfo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.studentVar = appDelegate.getSingleStudent(id: studentVar!.id)
        tableview.dataSource = self
        tableview.delegate = self
        
        pastExams = []
        futureExams = []
        
        print(studentVar!.id)
        print(studentVar!.exams!.count)
        for exam in studentVar!.exams! {

            
            if  exam.date <= Date() {
                pastExams.append(exam)
            } else {
                futureExams.append(exam)
            }
            
        }
        print("Exams.count")
        print(pastExams.count)
        print(futureExams.count)
        tableview.reloadData()
    }
    

    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        getMyInfo()
        tableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyInfo()

    }


    @IBAction func editExam(_ sender: Any) {
        isEditing = !isEditing
        
    }
    
    //var indexesSelectionDict: [String : IndexSet] = [:]
    var selectedRows : [IndexPath] = []

    @IBAction func deleteRows(_ sender: Any) {
        
        selectedRows = tableview.indexPathsForSelectedRows!
        //print(selectedRows)
        var items = [Int]()
        for indexPath in selectedRows  {
            items.append((studentVar?.exams![indexPath.row].id)!)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for item in items {
            appDelegate.deleteExam(examId: item)
        }
        getMyInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExam" {
             let vc = segue.destination as! AddExamViewController
             vc.studentVar = studentVar
            vc.delegate = self
        }
    }
    
    var selectedItems = Array<Int>()
}

extension ExamViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if examStatus.selectedSegmentIndex == 0
        {return futureExams.count}
        else
        {
        return pastExams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell") as! ExamTableViewCell
        cell.unit.text  = String((studentVar?.exams![indexPath.row].id)!)
        
        if examStatus.selectedSegmentIndex == 0
        {
                  
            cell.unit.text  = futureExams[indexPath.row].date.description
            
        }
        else
        {
            cell.unit.text  = pastExams[indexPath.row].date.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
}
