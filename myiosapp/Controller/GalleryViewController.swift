//
//  GalleryViewController.swift
//  myiosapp
//
//  Created by MacBook Pro on 23/10/20.
//

import UIKit

class GalleryViewController: UIViewController {

    var avatar = ["f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15","f16","f17"]
    @IBOutlet weak var gallery: UICollectionView!
    var delegate: ImageSelected?
    override func viewDidLoad() {
        super.viewDidLoad()

        gallery.delegate = self
        gallery.dataSource = self
        
        
        
            }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GalleryViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCell
        
        cell.avatarImage.image = UIImage(named: avatar[indexPath.row])

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        self.delegate?.imageSelected(emoji:avatar[indexPath.row])
        print(avatar[indexPath.row])
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


protocol ImageSelected {
    func imageSelected(emoji:String)
}
