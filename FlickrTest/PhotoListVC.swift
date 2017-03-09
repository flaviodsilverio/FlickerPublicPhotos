//
//  PhotoListVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class PhotoListVC: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let requestClient = RequestClient.sharedInstance
    var user : User = User()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.collectionView.reloadData()
        }
    }
    
    func failed(withMessage message: String?){
        
        DispatchQueue.main.sync {
            
            self.view.set(isLoading: false)
            collectionView.reloadData()
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! PhotoDetailsVC
        destination.photo = user.photos[(collectionView.indexPath(for: sender as! UICollectionViewCell)?.row)!]
    }
    
    //MARK: Actions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        user.photos = [Photo]()
        
        if (searchBar.text?.characters.count)! > 0 {
            self.view.set(isLoading: true)
            let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
            searchBar.resignFirstResponder()
            
            requestClient.load(userWithName: text!, completion: { [weak self] (success, errorMessage) in
                if success {
                    self?.loaded()
                } else {
                    self?.failed(withMessage: errorMessage)
                }
            })
        } else {
            collectionView.show(noDataViewWithText: "Invalid Username Format")
        }
    }
}




