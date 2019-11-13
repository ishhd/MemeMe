//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Ebtesam on 23/02/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController : UIViewController {
    var meme : Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        self.imageView.image = meme.memedImage
        
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}
