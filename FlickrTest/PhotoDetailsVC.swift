//
//  PhotoDetailsVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class PhotoDetailsVC: UITableViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let requestClient = RequestClient.sharedInstance
    
    var photo : Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.set(isLoading: true)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        requestClient.load(photoDetailsForPhoto: photo) { [weak self] (success, errorMessage) in
            
            if success {
                self?.loaded()
            } else {
                self?.failed(withMessage: errorMessage)
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "showOriginalPhoto", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! OriginalPhotoVC
        destination.originalPhotoURLString = "https://www.flickr.com/photos/27543985@N00/718871/"
    }

    func loaded(){
        
        DispatchQueue.main.sync {
            self.view.set(isLoading: false)
            thumbnailImageView.setImage(forItem: photo, inPosition: 0)
            titleLabel.text = photo.title
            viewsLabel.text = photo.views ?? "N/A"
            dateLabel.text = photo.dateTaken ?? "N/A"
            descriptionLabel.text = photo.description ?? "N/A"

        }
    }
    
    func failed(withMessage message: String?){
        
        DispatchQueue.main.sync {
            
            self.view.set(isLoading: false)
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
    }
}
