//
//  TestViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 23/10/20.
//

import UIKit
import fluid_slider
class TestViewController: UIViewController {

    @IBOutlet var slider: Slider!
    @IBOutlet var label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @objc
    func sliderValueChanged(sender: Slider){
        var number = (slider.fraction * 100)
        number.round()
        print( Int(number))
    }
    

    private func setLabelHidden(_ hidden: Bool, animated: Bool) {
        let animations = {
            self.label.alpha = hidden ? 0 : 1
        }
        if animated {
            UIView.animate(withDuration: 0.11, animations: animations)
        } else {
            animations()
        }
    }
    
}
