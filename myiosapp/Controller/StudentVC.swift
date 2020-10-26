


import UIKit
import CoreData
import ViewAnimator



class StudentVC: UIViewController {
    
    
    // IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // Leteral
    let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
    let appDelegate = UIApplication.shared.delegate
    
    
    // Var
    var filteredData = [MyStudent]()
    var isSearching = false
    var students: [MyStudent] = []
    
    

 
    // prepare the view for the main appearance
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyInfo()
        tableView.delegate = self
        tableView.dataSource = self
        isSearching = false
        searchBar.delegate  = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // set the background properities
        self.view.setGradientBackground(colorTop: UIColor.mypink , colorBottom: UIColor.myyellow)
        tableView.backgroundColor = .clear
        searchBar.backgroundColor = .clear
    }
    
    
    // Prepare the view before appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMyInfo()
        tableView.delegate = self
        tableView.dataSource = self
        isSearching = false
        searchBar.delegate  = self
        searchBar.returnKeyType = UIReturnKeyType.done
        tableView.reloadData()
        
    }
    
    // Reload the data for the table from the Cre data
    func getMyInfo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.students = appDelegate.getAllStudents()
        self.students.sort(by: { $0.fname > $1.fname })
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: {
        })
    }
    
}// VC ends





extension StudentVC : UITableViewDelegate , UITableViewDataSource  {
    
    // Set the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredData.count
        }
        return students.count
    }
    
    // Set the dimention of the table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Navigate to the student detain view on selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! StudentDetailVC
        
        if isSearching{ newVC.studentVar = filteredData[indexPath.row]}
        else
        {newVC.studentVar = students[indexPath.row]}
        
        self.show(newVC, sender: self)
        
    }
    
    
    // Call the row for the student
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StudentTVC
        cell.selectionStyle = .none
        
        cell.backgroundColor = .clear
        
        // Return only the searching result
        if isSearching{
            
            cell.id.text = String(self.filteredData[indexPath.row].id)
            cell.name.text = self.filteredData[indexPath.row].fname+" "+self.filteredData[indexPath.row].lname
            
            cell.course.text = self.filteredData[indexPath.row].course
            cell.avatarImage.image = UIImage(named: filteredData[indexPath.row].image)
            
        }
        else // return all result of no searching is going on
        {
        
            cell.id.text = String(self.students[indexPath.row].id)
            cell.name.text = self.students[indexPath.row].fname+" "+self.students[indexPath.row].lname
            cell.course.text = self.students[indexPath.row].course
            cell.avatarImage.image = UIImage(named: students[indexPath.row].image)            }
        
        
        
        return cell
    }
    
    // Delete data based on user selection
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            appDelegate.deleteSingleStudent(id: students[indexPath.row].id)
            getMyInfo()
            tableView.reloadData()
            
        }
    }
    
}


// Handle the search for the students
extension StudentVC : UISearchBarDelegate {
    
    // Handle the seearch event
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Deactivate search if its empty
        if searchBar.text == "" || searchBar.text == nil{
            view.endEditing(true)
            isSearching = false;
            tableView.reloadData()
        }
        else{
            
            // activate search and set search values
            filteredData = [MyStudent]()
            isSearching = true
            ifSearchContains(word: searchBar.text!)
            tableView.reloadData()

        }
    }
    
    
    // Identify the searching elemnt based on first name
    func ifSearchContains(word : String)
    {
        for result in students{
            if result.fname.contains(word){
                filteredData.append(result)
            }else{
                
            }
        }
    }
    
}


