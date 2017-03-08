//
//  PhotoListVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class PhotoListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RequestClientDelegate {
    
    let requestClient = RequestClient.sharedInstance
    
    var user : User = User()
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestClient.delegate = self
        requestClient.user = user
        
        collectionView.show(noDataViewWithText: "Search for a username")

    }
    
    //MARK: Collection Data Source and delegate

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
    
    
    //MARK: Request Delegate Methods
    
    func loaded() {
        
        DispatchQueue.main.sync {
            
            self.view.set(isLoading: false)
            
            if user.photos.count > 0 {
                collectionView.hideNoDataView()
                self.collectionView.reloadData()
            } else {
                collectionView.show(noDataViewWithText: "User has no Public Photos")
            }
            
        }
        
    }
    
    func failed(withMessage message: String){
        
        DispatchQueue.main.sync {
            userNameTextField.resignFirstResponder()
            self.view.set(isLoading: false)
            collectionView.reloadData()
            collectionView.show(noDataViewWithText: message)
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! PhotoDetailsVC
        destination.photo = user.photos[(collectionView.indexPath(for: sender as! UICollectionViewCell)?.row)!]
        
    }
    
    //MARK: Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        user.photos = [Photo]()

        if (userNameTextField.text?.characters.count)! > 0 {
            self.view.set(isLoading: true)
            let text = userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
            userNameTextField.resignFirstResponder()

            requestClient.load(userWithName: text!)
        } else {
            collectionView.show(noDataViewWithText: "Invalid Username Format")
        }
    }
    


}




