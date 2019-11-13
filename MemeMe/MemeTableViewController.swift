//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ebtesam on 22/02/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController {

var memes : [Meme]!{
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    return appDelegate.memes
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTable")!
        let meme = self.memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier : "DetailsViewController") as! DetailsViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    

}
