//
//  ViewController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit
import CoreData




class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(students[indexPath.row])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        newVC.studentVar = students[indexPath.row]
        self.show(newVC, sender: self)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StudentTableViewCell
        
        cell.id.text = String(self.students[indexPath.row].id)
        cell.name.text = self.students[indexPath.row].fname+" "+self.students[indexPath.row].lname

        cell.course.text = self.students[indexPath.row].course
        cell.location.text = String(self.students[indexPath.row].lat)
        cell.avatarImage.image = UIImage(named: students[indexPath.row].image)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
                appDelegate.deleteSingleStudent(id: students[indexPath.row].id)
                getMyInfo()
                tableView.reloadData()
             
        }
    
    }
        
    var students: [MyStudent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Did load code")
        getMyInfo()
        tableView.delegate = self
        tableView.dataSource = self
        
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //print("Will appear code")
        getMyInfo()
        self.tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.addExam()
    }
    
    let appDelegate = UIApplication.shared.delegate
    
    func getMyInfo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.students = appDelegate.getAllStudents()
        print(appDelegate.isUniqueId(id: 2))
    }


}



