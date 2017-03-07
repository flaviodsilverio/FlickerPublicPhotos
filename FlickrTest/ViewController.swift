//
//  ViewController.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RequestClientDelegate {

    var queue = OperationQueue()
    var items = [ImageHelper]()
    var requestClient = RequestClient()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestClient.delegate = self
        requestClient.load(userWithName: "franckinjapan")
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        load(userWithName: "franckinjapan")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sideSize = collectionView.frame.size.width / 2 - 8
        
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
        let imageView = cell.viewWithTag(10001) as! UIImageView
        
        if items[indexPath.row].image == nil {
            
            imageView.image = UIImage(named:"placeholder")
            cell.tag = indexPath.row
            
            requestClient.load(imageDetailsForID: items[indexPath.row].imageID, completion: {
                [weak self] (image : UIImage?, imageID : String)  in
                
                if indexPath.row == cell.tag {
                    
                    DispatchQueue.main.sync {
                        imageView.image = image
                    }
                    
                }
                
                self?.items[indexPath.row].image = image
            })
            
        } else {
            imageView.image = items[indexPath.row].image
        }
        
        print("cell")
        
        return cell
    }
    
    func loaded(userPhotos photos: [ImageHelper]) {
        
        self.items = photos
        
        DispatchQueue.main.sync {
            self.collectionView.reloadData()
        }

    }

}

class ImageHelper{
    var imageID : String = ""
    var image : UIImage?
}


/*
 https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=956355626648d3053ddfec23e6b26d7f&photo_id=32440792383&format=json&nojsoncallback=1
 */




