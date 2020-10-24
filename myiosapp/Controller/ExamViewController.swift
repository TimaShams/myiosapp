
import UIKit
import DateTimePicker
import ViewAnimator

extension ExamViewController: BackToList {
  func willReturn() {
    self.getMyInfo()
  }
}

class ExamViewController: UIViewController {
    
    
    var releaseDate: NSDate?
    var countdownTimer = Timer()

    func startTimer( date : Data) {

        let releaseDateString = "2020-11-16 08:00:00"
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate

        countdownTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc func updateTime() {

        let currentDate = Date()
        let calendar = Calendar.current

        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)

        let countdown = "Days \(diffDateComponents.day ?? 0), Hours \(diffDateComponents.hour ?? 0), Minutes \(diffDateComponents.minute ?? 0), Seconds \(diffDateComponents.second ?? 0)"

        print(countdown)
//self.tableview.reloadData()
        self.collectionView.reloadData()
    }
    
    
    
    

    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var examStatus: UISegmentedControl!
    //@IBOutlet weak var tableview: UITableView!
    
    var picker: DateTimePicker?
    var pastExams : [MyExam] = []
    var futureExams : [MyExam] = []
    var studentVar: MyStudent? = nil
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
//        tableview.rowHeight = UITableView.automaticDimension
//        tableview.allowsMultipleSelection = true
        collectionView.allowsMultipleSelection = true
        
        self.getMyInfo()
        examStatus.addTarget(self, action: #selector(self.indexChanged(_:)), for: .valueChanged)
    }
    
    
    func getMyInfo(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.studentVar = appDelegate.getSingleStudent(id: studentVar!.id)
//        tableview.dataSource = self
//        tableview.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        
//        UIView.animate(views: tableview.visibleCells, animations: animations, completion: {
//
//        })
        UIView.animate(views: collectionView.visibleCells, animations: animations, completion: {
        
        })
        
    
    collectionView.reloadData()
        print("Exams.count")
        print(pastExams.count)
        print(futureExams.count)
        //tableview.reloadData()
    

    }
    

    @objc func indexChanged(_ sender: UISegmentedControl) {
        
        getMyInfo()
        //tableview.reloadData()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyInfo()

    }


    
    //var indexesSelectionDict: [String : IndexSet] = [:]
    var selectedRows : [IndexPath] = []
    var selectedRows2 : [IndexPath] = []

    @IBAction func deleteRows(_ sender: Any) {
        
        //selectedRows = tableview.indexPathsForSelectedRows!
        selectedRows2 = collectionView.indexPathsForSelectedItems!

        //print(selectedRows)
        var items = [Int]()
        var items2 = [Int]()
//
//        for indexPath in selectedRows  {
//            items.append((studentVar?.exams![indexPath.row].id)!)
//        }
        
        for indexPath in selectedRows2  {
            items2.append((studentVar?.exams![indexPath.row].id)!)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//        for item in items {
//            appDelegate.deleteExam(examId: item)
//        }
        
        for item in items2 {
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
        
        cell.content.layer.borderColor
            = UIColor.mybrown.cgColor
       
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if examStatus.selectedSegmentIndex == 0
        {
            
            let currentDate = Date()
            let calendar = Calendar.current

            let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: futureExams[indexPath.row].date)

            let countdown = "Days \(diffDateComponents.day ?? 0) Hours \(diffDateComponents.hour ?? 0) Minutes \(diffDateComponents.minute ?? 0) left"


            let timeString = formatter.string(from: futureExams[indexPath.row].date)
            cell.unit.text  = futureExams[indexPath.row].unit
            cell.date.text  = futureExams[indexPath.row].date.string(format: "yyyy-MM-dd")
            cell.time.text  = timeString
            cell.remaining.text = countdown
            cell.location.text  = futureExams[indexPath.row].location
        }
        else
        {
            let timeString = formatter.string(from: pastExams[indexPath.row].date)

            cell.unit.text  = pastExams[indexPath.row].unit
            cell.date.text  = pastExams[indexPath.row].date.string(format: "yyyy-MM-dd")
            cell.time.text  = timeString
            cell.location.text  = pastExams[indexPath.row].location
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 180
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell") as! ExamTableViewCell

        cell.backgroundColor = .white
        cell.content.layer.borderColor
            = UIColor.mypink.cgColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examCell") as! ExamTableViewCell

        cell.content.layer.borderColor
            = UIColor.mybrown.cgColor
    }
    
    
}



extension ExamViewController: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if examStatus.selectedSegmentIndex == 0
        {return futureExams.count}
        else
        {
        return pastExams.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "examCC", for: indexPath) as! ExamCVC
        
        cell.content.design()
        cell.content.layer.borderColor
            = UIColor.mybrown.cgColor
       
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if examStatus.selectedSegmentIndex == 0
        {
            
            let currentDate = Date()
            let calendar = Calendar.current

            let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: futureExams[indexPath.row].date)

            let countdown = "\(diffDateComponents.day ?? 0) D & \(diffDateComponents.hour ?? 0) H & \(diffDateComponents.minute ?? 0) M left"


            let timeString = formatter.string(from: futureExams[indexPath.row].date)
            cell.unit.text  = futureExams[indexPath.row].unit
            cell.date.text  = futureExams[indexPath.row].date.string(format: "yyyy-MM-dd")
            cell.time.text  = timeString
            cell.counter.text = countdown
            cell.location.text  = futureExams[indexPath.row].location
        }
        else
        {
            let timeString = formatter.string(from: pastExams[indexPath.row].date)

            cell.unit.text  = pastExams[indexPath.row].unit
            cell.date.text  = pastExams[indexPath.row].date.string(format: "yyyy-MM-dd")
            cell.time.text  = timeString
            cell.counter.text = ""
            cell.location.text  = pastExams[indexPath.row].location
        }
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        let cell = collectionView
//          .dequeueReusableCell(withReuseIdentifier: "examCC", for: indexPath) as! ExamCVC
//        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! ExamCVC
        selectedCell.backgroundColor = UIColor.myorange
        
//        cell.content.backgroundColor = UIColor.myorange
//        cell.content.layer.borderColor
//            = UIColor.mypink.cgColor
//        print("Selected")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let cellToDeselect:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! ExamCVC
        cellToDeselect.backgroundColor = .clear
        
    }
    
    
    class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
    {
        //MARK: - UICollectionViewDelegateFlowLayout

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
           return CGSize(width: 100.0, height: 100.0)
        }
    }
    
}


