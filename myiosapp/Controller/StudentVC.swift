//
//  ViewController.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator



class StudentVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
    let appDelegate = UIApplication.shared.delegate

    
    var filteredData = [MyStudent]()
    var isSearching = false

        
    var students: [MyStudent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Did load code")
        getMyInfo()
        tableView.delegate = self
        tableView.dataSource = self
        isSearching = false
        searchBar.delegate  = self
        searchBar.returnKeyType = UIReturnKeyType.done
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
    
    func setBG(){
        
        var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.mypink, UIColor.myorange]//Colors you want to add
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = CGRect.zero
           return gradientLayer
        }()
        
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

    
    func getMyInfo(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.students = appDelegate.getAllStudents()
        self.students.sort(by: { $0.id > $1.id })
        

        UIView.animate(views: tableView.visibleCells, animations: animations, completion: {
        
        })
    }

}


extension StudentVC : UITableViewDelegate , UITableViewDataSource  {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return filteredData.count
        }
        return students.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(students[indexPath.row])
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        
        
        if isSearching{ newVC.studentVar = filteredData[indexPath.row]}
        else
        
        {newVC.studentVar = students[indexPath.row]}
        
        self.show(newVC, sender: self)

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StudentTVC
        cell.selectionStyle = .none
        
        if isSearching{
            
            cell.id.text = String(self.filteredData[indexPath.row].id)
            cell.name.text = self.filteredData[indexPath.row].fname+" "+self.filteredData[indexPath.row].lname

            cell.course.text = self.filteredData[indexPath.row].course
            //cell.location.text = String(self.filteredData[indexPath.row].lat)
            cell.avatarImage.image = UIImage(named: filteredData[indexPath.row].image)
            
            }
            else
            {
                cell.id.text = String(self.students[indexPath.row].id)
                cell.name.text = self.students[indexPath.row].fname+" "+self.students[indexPath.row].lname

                cell.course.text = self.students[indexPath.row].course
                //cell.location.text = String(self.students[indexPath.row].lat)
                cell.avatarImage.image = UIImage(named: students[indexPath.row].image)            }
        


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

}

extension StudentVC : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil{
            view.endEditing(true)
            isSearching = false;
            tableView.reloadData()
        }
        else{
            filteredData = [MyStudent]()
            isSearching = true
            ifSearchContains(word: searchBar.text!)
            tableView.reloadData()
            print(filteredData)
            print(students)
            print(searchBar.text)
        }
    }

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


