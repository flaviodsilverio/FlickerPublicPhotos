//
//  ViewController.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RequestClientDelegate {

    var queue = OperationQueue()
    var items = [ImageHelper]()
    
    let requestClient = RequestClient.sharedInstance
    
    var user : User = User()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestClient.delegate = self
        requestClient.user = user
        requestClient.load(userWithName: "franckinjapan")

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sideSize = collectionView.frame.size.width / 2 - 8
        
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        
        cell.imageView.setImage(forItem: user.photos[indexPath.row], inPosition: indexPath.row)
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPhotoDetails", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as! PhotoDetailsVC
        destination.photo = user.photos[(collectionView.indexPath(for: sender as! UICollectionViewCell)?.row)!]
    
    }
    
    func loaded(userPhotos photos: [ImageHelper]) {
        
        DispatchQueue.main.sync {
            self.collectionView.reloadData()
        }

    }

}

class ImageHelper{
    var imageID : String = ""
    var image : UIImage?
}




