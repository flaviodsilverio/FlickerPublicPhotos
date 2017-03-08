//
//  UIViewExtensions.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit


extension UIView {

    func set(isLoading: Bool){
    
        if isLoading {
        
            if self.viewWithTag(-101) != nil {
                return
            } else {
                let indicator = UIActivityIndicatorView(frame: self.bounds)
                indicator.startAnimating()
                indicator.tag = -101
                indicator.backgroundColor = UIColor.gray
                self.addSubview(indicator)
            }
            
        } else {
            self.viewWithTag(-101)?.removeFromSuperview()
        }
        
    }
    
    func show(noDataViewWithText text: String) {
        
        let label = self.viewWithTag(-102) as? UILabel ?? UILabel(frame: CGRect(x:0,y:0,width:self.frame.width,height: 50))
        label.tag = -102
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = text
        self.addSubview(label)
    
    }
    
    func hideNoDataView(){
        self.viewWithTag(-102)?.removeFromSuperview()
    }

}
