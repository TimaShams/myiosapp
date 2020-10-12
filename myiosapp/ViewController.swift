//
//  ViewController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit
import CoreData


struct MyStudent {
    var id: Int
    var fname: String
    var lname: String
    var gender: String
    var dob: String
    var course: String
    var lat  :Double
    var long : Double
}


class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addStudent(_ sender: Any) {
        //present(AddRecordController(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StudentTableViewCell
        
        cell.id.text = String(self.students[indexPath.row].id)
        cell.name.text = self.students[indexPath.row].fname+" "+self.students[indexPath.row].lname
        cell.genderAge.text = self.students[indexPath.row].gender+" "+self.students[indexPath.row].dob
        cell.course.text = self.students[indexPath.row].course
        cell.location.text = String(self.students[indexPath.row].lat)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            print(students[indexPath.row].fname)
            fetchRequest.predicate = NSPredicate(format: "surname = %@", students[indexPath.row].fname)
            
            do
             {
                 let test = try managedContext.fetch(fetchRequest)
                 
                 let objectToDelete = test[0] as! NSManagedObject
                 managedContext.delete(objectToDelete)
                 
                 do{
                     try managedContext.save()
                     print("Deleted")
                     getPersonInfo()
                 }
                 catch
                 {
                     print(error)
                 }
                 
                
             }
             catch
             {
                 print(error)
             }
            
            
        }
    
    }
        
    var students: [MyStudent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Did load code")

        getPersonInfo()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Will appear code")
        getPersonInfo()
    }
    func getPersonInfo () {
        
        // j[vfm 
        students = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                
                let id = trans.value(forKey: "identification") as! Int
                let surname = trans.value(forKey: "surname") as! String
                let givenName = trans.value(forKey: "givenName") as! String
                let strDate = dateFormatter.string(from: trans.value(forKey: "dateOfBirth") as! Date)
                let student: MyStudent = MyStudent(id: id, fname: surname, lname: givenName, gender: "Male", dob: strDate, course: "MICT", lat: 0.0, long: 0.0)
                students.append(student)
                //info = info + id + ", " + givenName + " " + surname + ", " + strDate + "\n"
            }
        } catch {
            print("Error with request: \(error)")
        }
        tableView.reloadData()

    }
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    


}



