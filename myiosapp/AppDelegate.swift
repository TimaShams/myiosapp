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

        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "myiosapp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
    

    
    // Save
    func storeStudentInfo (student:MyStudent) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(student.id, forKey: "id")
        transc.setValue(student.fname, forKey: "fname")
        transc.setValue(student.lname, forKey: "lname")
        transc.setValue(student.gender, forKey: "gender")
        transc.setValue(student.course, forKey: "course")
        transc.setValue(student.age, forKey: "age")
        transc.setValue(student.lat, forKey: "lat")
        transc.setValue(student.long, forKey: "long")
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    func getstudentInfo () -> [MyStudent] {

        var students: [MyStudent] = []

        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")

        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)

            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")

            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {

                let id = trans.value(forKey: "id") as! Int
                let fname = trans.value(forKey: "fname") as! String
                let lname = trans.value(forKey: "lname") as! String
                let gender = trans.value(forKey: "gender") as! String
                let course = trans.value(forKey: "course") as! String
                let age = trans.value(forKey: "age") as! Int
                let long = trans.value(forKey: "long") as! Double
                let lat = trans.value(forKey: "lat") as! Double

        
                let student: MyStudent = MyStudent(id: id, fname: fname, lname: lname, gender: gender, course: course, age: age, lat: 0.0, long: 0.0)
                
                students.append(student)
                //info = info + id + ", " + givenName + " " + surname + ", " + strDate + "\n"
            }
        } catch {
            print("Error with request: \(error)")
        }
        return students
    }

    
    
//    func getPersonInfo () -> String {
//        var info = ""
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//
//        //create a fetch request, telling it about the entity
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//
//        do {
//            //go get the results
//            let searchResults = try getContext().fetch(fetchRequest)
//
//            //I like to check the size of the returned results!
//            print ("num of results = \(searchResults.count)")
//
//            //You need to convert to NSManagedObject to use 'for' loops
//            for trans in searchResults as [NSManagedObject] {
//                let id = String(trans.value(forKey: "identification") as! Int)
//                let surname = trans.value(forKey: "surname") as! String
//                let givenName = trans.value(forKey: "givenName") as! String
//                let strDate = dateFormatter.string(from: trans.value(forKey: "dateOfBirth") as! Date)
//                info = info + id + ", " + givenName + " " + surname + ", " + strDate + "\n"
//            }
//        } catch {
//            print("Error with request: \(error)")
//        }
//        return info;
//    }
    
    func removeAllStudents () {
        let context = getContext()
        // delete everything in the table Person
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
    
    
    
    func checkStudentExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        var entitiesCount = 0

        do {
            entitiesCount = try getContext ().count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return entitiesCount > 0
    }
    
    

}

