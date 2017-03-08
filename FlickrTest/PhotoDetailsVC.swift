//
//  PhotoDetailsVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class PhotoDetailsVC: UITableViewController {

    @IBOutlet var photoThumbnail: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var isFamilyLabel: UILabel!
    
    @IBOutlet weak var isFriendLabel: UILabel!
    var photo : Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoThumbnail.image = photo.images.thumbnail
        
        nameLabel.text = photo.title
        isFamilyLabel.text = "\(photo.isFamily)"
        isFriendLabel.text =  "\(photo.isFriend)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
        
        }
    }

}
