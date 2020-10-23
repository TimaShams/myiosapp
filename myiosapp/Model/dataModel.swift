//
//  dataModel.swift
//  myiosapp
//
//  Created by MacBook Pro on 19/10/20.
//

import Foundation


struct MyStudent {
    var id: Int
    var fname: String
    var lname: String
    var gender: String
    var course: String
    var age: Int
    var lat  :Double
    var long : Double
    var exams: [MyExam]?
    var image: String
    var address : String
}


struct MyExam : Hashable {
    var id : Int
    var unit: String
    var date: Date
    var location: String
}
