//
//  GalleryViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 23/10/20.
//

import UIKit

class GalleryVC: UIViewController {

    // List of images names that are stored in the app
    var avatar = ["f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15","f16","f17"]
    
    
    @IBOutlet weak var gallery: UICollectionView!
    var delegate: ImageSelected?
    override func viewDidLoad() {
        super.viewDidLoad()

        gallery.delegate = self
        gallery.dataSource = self
        
        
    }

}


extension GalleryVC: UICollectionViewDataSource,UICollectionViewDelegate{
    
    // Get the number of items in the view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatar.count
    }
    
    // Return the cell based on the selected index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCell
        
        cell.avatarImage.image = UIImage(named: avatar[indexPath.row])

        return cell
    }
    
    
    // Pop back the the main view controller and send the selected image details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.imageSelected(emoji:avatar[indexPath.row])
        print(avatar[indexPath.row])
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// Transfer the value to the main view controller 
protocol ImageSelected {
    func imageSelected(emoji:String)
}
