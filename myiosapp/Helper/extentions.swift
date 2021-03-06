//
//  extentions.swift
//  myiosapp
//
//  Created by MacBook Pro on 23/10/20.
//

import Foundation
import UIKit

extension UIView{
    func design() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }

}



extension UIColor {
    static let mygreen = #colorLiteral(red: 0.5572376847, green: 0.7272785306, blue: 0.6576042175, alpha: 1)
    static let myyellow = #colorLiteral(red: 0.9966161847, green: 0.9848737121, blue: 0.8147788644, alpha: 1)
    static let myorange = #colorLiteral(red: 0.9914490581, green: 0.8126142621, blue: 0.7166959643, alpha: 1)
    static let mypink = #colorLiteral(red: 0.9564401507, green: 0.5099343657, blue: 0.54938519, alpha: 1)
    static let mybrown = #colorLiteral(red: 0.4652374387, green: 0.3635293841, blue: 0.416199863, alpha: 1)
}


extension Date {

    func setTime(hour : Int , min : Int) -> Date?
    {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = hour
        components.minute = min
        components.second = 0

        return calendar.date(from: components)
    }

}
    

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
}
}

