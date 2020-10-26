
import UIKit
import DateTimePicker
import ViewAnimator

extension ExamVC: BackToList {
  func willReturn() {
    self.getMyInfo()
  }
}


class ExamVC: UIViewController {
    
    // var
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    var selectedItems = Array<Int>()
    var picker: DateTimePicker?
    var pastExams : [MyExam] = []
    var futureExams : [MyExam] = []
    var studentVar: MyStudent? = nil
    
    // IBOutlet
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var examStatus: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // Prepare the first presence of the view
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        self.getMyInfo()
        collectionView.backgroundColor = .clear
        examStatus.addTarget(self, action: #selector(self.indexChanged(_:)), for: .valueChanged)
        
        self.view.setGradientBackground(colorTop: UIColor.myyellow , colorBottom: UIColor.mygreen)

    }
    
    // Prepare for the reappearance of the view 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyInfo()

    }

    
    // count the number of days left before the exam
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

        self.collectionView.reloadData()
    }
    
    
    // Get the student info from Core data
    func getMyInfo(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.studentVar = appDelegate.getSingleStudent(id: studentVar!.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Initaite the variables
        selectedRows2 = []
        pastExams = []
        futureExams = []
        

        // devide the exams by past and future
        for exam in studentVar!.exams! {
            
            if  exam.date <= Date() {
                pastExams.append(exam)
            } else {
                futureExams.append(exam)
            }
        }
        
        // animate the view
        let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        
        UIView.animate(views: collectionView.visibleCells, animations: animations, completion: {
        
        })
        

    collectionView.reloadData()

    }
    

    // Chnage data based on index
    @objc func indexChanged(_ sender: UISegmentedControl) {
        getMyInfo()
        collectionView.reloadData()
    }
    
    
    var selectedRows2 : [IndexPath] = []

    @IBAction func deleteRows(_ sender: Any) {
        
        selectedRows2 = collectionView.indexPathsForSelectedItems!
        
        var items2 = [Int]()

        // get the index to remove
        for indexPath in selectedRows2  {
            items2.append((studentVar?.exams![indexPath.row].id)!)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // delete the items based on the selected id
        for item in items2 {
            appDelegate.deleteExam(examId: item)
        }

        // update view items
        getMyInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExam" {
             let vc = segue.destination as! AddExamVC
             vc.studentVar = studentVar
            vc.delegate = self
        }
    }
    
}


extension ExamVC: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    // Return the numbr of exams to present in the view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if examStatus.selectedSegmentIndex == 0
        {return futureExams.count}
        else
        {
        return pastExams.count
        }
    }
    
    
    // Get the correct cell for the index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "examCC", for: indexPath) as! ExamCVC
        
        // Design the cell
        cell.content.design()
        cell.content.layer.borderColor
            = UIColor.mybrown.cgColor
       
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if examStatus.selectedSegmentIndex == 0 // Set future exams values on the cell 
        {
            
            let currentDate = Date()
            let calendar = Calendar.current

            let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: futureExams[indexPath.row].date)

            // Set the remaining days
            let countdown = "\(diffDateComponents.day ?? 0) D & \(diffDateComponents.hour ?? 0) H & \(diffDateComponents.minute ?? 0) M left"


            let timeString = formatter.string(from: futureExams[indexPath.row].date)
            cell.unit.text  = futureExams[indexPath.row].unit
            cell.date.text  = futureExams[indexPath.row].date.string(format: "yyyy-MM-dd")
            cell.time.text  = timeString
            cell.counter.text = countdown
            cell.location.text  = futureExams[indexPath.row].location
        }
        else // Set past exams values
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
    
    
    // Change the item background on select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! ExamCVC
        selectedCell.backgroundColor = UIColor.myorange
        
    }
    
    
    // Change the item background on deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let cellToDeselect:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! ExamCVC
        cellToDeselect.backgroundColor = .clear
        
    }
    
    
    // Set the dimention for the collection view cell
    class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
    {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
           return CGSize(width: 100.0, height: 100.0)
        }
    }
    
}


