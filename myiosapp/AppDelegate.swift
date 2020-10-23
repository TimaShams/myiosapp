//
//  AppDelegate.swift
//  CoreDataSample
//
//  Created by vinh on 16/9/20.
//  Copyright © 2020 UWS. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyB6KU-RrTTmlr5Ix0Lj0XK_POgPsf0jhsM")
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "myiosapp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // all functions for core data are here
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

    
    // save Student
    func insertStudent (student:MyStudent) {
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        transc.setValue(student.id, forKey: "id")
        transc.setValue(student.fname, forKey: "fname")
        transc.setValue(student.lname, forKey: "lname")
        transc.setValue(student.gender, forKey: "gender")
        transc.setValue(student.course, forKey: "course")
        transc.setValue(student.age, forKey: "age")
        transc.setValue(student.lat, forKey: "lat")
        transc.setValue(student.long, forKey: "long")
        transc.setValue(student.image, forKey: "image")
        transc.setValue(student.address, forKey: "address")

        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    func getAllStudents () -> [MyStudent] {

        var students: [MyStudent] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")

        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")

            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                
                let id = trans.value(forKey: "id") as! Int
                let fname = trans.value(forKey: "fname") as! String
                let lname = trans.value(forKey: "lname") as! String
                let gender = trans.value(forKey: "gender") as! String
                let course = trans.value(forKey: "course") as! String
                let long = trans.value(forKey: "long") as! Double
                let lat = trans.value(forKey: "lat") as! Double
                let age = trans.value(forKey: "age") as! Int
                let image = trans.value(forKey: "image") as! String
                let address = trans.value(forKey: "address") as! String

                
                var student: MyStudent = MyStudent(id: id, fname: fname, lname: lname, gender: gender, course: course, age: age, lat: lat, long: long , image: image , address : address )
                
                let examItems : NSMutableSet = trans.mutableSetValue(forKey: "examItems")
                
                var exams : [MyExam] = []
                for exam in examItems {
                    let id_ = (exam as! Exam).id
                    let loc_ = (exam as! Exam).location
                    let unit_ = (exam as! Exam).unit
                    let date_ = (exam as! Exam).date!
                    let ee : MyExam = MyExam(id: Int(id_), unit: unit_!, date: date_, location: loc_!)
                    exams.append(ee)
                }
                //print(exams)
                student.exams = exams
                students.append(student)

            }
        } catch {
            print("Error with request: \(error)")
        }
        return students
    }

    
    
    func removeAllStudents () {
        let context = getContext()

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    func deleteSingleStudent(id:Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        do
         {
             let test = try managedContext.fetch(fetchRequest)
             let objectToDelete = test[0] as! NSManagedObject
             managedContext.delete(objectToDelete)
             do{
                 try managedContext.save()
                 print("Deleted")
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
    
    
    func getSingleStudent(id:Int) -> MyStudent {
        
        var studentTemp: MyStudent? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        do
        
        
         {
             let test = try getContext().fetch(fetchRequest)
             let student = test[0] as! NSManagedObject
        
            //print("print a single student value")
            let id     = student.value(forKey: "id")     as! Int
            let fname  = student.value(forKey: "fname")  as! String
            let lname  = student.value(forKey: "lname")  as! String
            let gender = student.value(forKey: "gender") as! String
            let course = student.value(forKey: "course") as! String
            let long   = student.value(forKey: "long")   as! Double
            let lat    = student.value(forKey: "lat")    as! Double
            let age    = student.value(forKey: "age")    as! Int
            let image  = student.value(forKey: "image")  as! String
            let address  = student.value(forKey: "address")  as! String

            studentTemp = MyStudent(id: id, fname: fname, lname: lname, gender: gender, course: course, age: age, lat: lat, long: long , image: image , address: address)
            
            let examItems : NSMutableSet = student.mutableSetValue(forKey: "examItems")
            
            var exams : [MyExam] = []
            for exam in examItems {
                let id_    = (exam as! Exam).id
                let loc_   = (exam as! Exam).location
                let unit_  = (exam as! Exam).unit
                let date_  = (exam as! Exam).date
                let ee : MyExam = MyExam(id: Int(id_), unit: unit_!, date: date_!, location: loc_!)
                exams.append(ee)
            }
            
            //print(exams)
            studentTemp!.exams = exams

            return studentTemp!
         }
         catch
         {
             print(error)
         }
        
        return studentTemp!
        
    }
    
    
    
    func isUniqueId(id:Int) -> Bool {
        
        var studentTemp: MyStudent? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        do
         {
             let test = try getContext().fetch(fetchRequest)
            if(test.count == 0)
            {return true}
            else
            {return false}
            
         }
         catch
         {
             print(error)
         }
        
        return false
    }
    
    func addExam(exam : MyExam , student:MyStudent){
        
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        fetchRequest.includesSubentities = false
        
        fetchRequest.predicate = NSPredicate(format: "id = %d", student.id)
        
    do {
        let searchResults = try getContext().fetch(fetchRequest)
        for trans in searchResults as [NSManagedObject] {
            let myRelatedItems : NSMutableSet = trans.mutableSetValue(forKey: "examItems")
            let entity =  NSEntityDescription.entity(forEntityName: "Exam", in: context)
            let examTemp : Exam = NSManagedObject(entity: entity!, insertInto: context) as! Exam
            
            examTemp.setValue(exam.id, forKey: "id")
            examTemp.setValue(exam.date, forKey: "date")
            examTemp.setValue(exam.location, forKey: "location")
            examTemp.setValue(exam.location, forKey: "unit")
            examTemp.setValue(trans, forKey: "examee")
            myRelatedItems.add(examTemp)
            
            }
        } catch {
            print("Error with request: \(error)")
        }
            
            
        saveContext ()
        
    }
    
    
    func deleteExam(examId : Int ){
                
        let examFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exam")
        examFetchRequest.predicate = NSPredicate(format: "id = %d", examId)

        do
         {
             let e = try getContext().fetch(examFetchRequest)
             let examToDelete = e[0]
             getContext().delete(examToDelete)
             saveContext ()
         }
         catch
         {
             print(error)
         }
        
    }
    
}

