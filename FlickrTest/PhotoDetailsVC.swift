//
//  PhotoDetailsVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class PhotoDetailsVC: UITableViewController, RequestClientDelegate {

    let requestClient = RequestClient.sharedInstance
    
    var photo : Photo! {
        didSet{
            requestClient.delegate = self
            self.view.set(isLoading: true)
            requestClient.load(photoDetailsForPhoto: photo)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.view.set(isLoading: false)
    }
    
    func failed(withMessage message: String){
        self.view.set(isLoading: false)
    }
}
