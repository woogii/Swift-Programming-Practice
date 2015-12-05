//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by Hyun on 2015. 11. 2..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // selected : the selection state of the cell. 
        self.selected = false
    }
    
    override var selected : Bool {
        didSet {
            let themeColor = (UIApplication.sharedApplication().delegate as! AppDelegate).themeColor
            self.backgroundColor = selected ? themeColor : UIColor.blackColor()
        }
    }
    
}
