//
//  OriginalPhotoVC.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 09/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class OriginalPhotoVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    
    var originalPhotoURLString : String = ""
    
    fileprivate var originalPhotoURL : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalPhotoURL = URL(string: originalPhotoURLString)
        let request = URLRequest(url: originalPhotoURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
