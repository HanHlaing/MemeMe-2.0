//
//  MemeTableViewController.swift
//  MemeMe-2.0
//
//  Created by Han Hlaing Moe on 08/08/2021.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Variables/Constants
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
        tableView!.rowHeight = 100
    }
    
    @IBAction func openMemeEditor(_ sender: Any) {
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeEditorController, animated: true, completion: nil)
    }
    
    // MARK: TableViewController Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        if !memes.isEmpty {
            let meme = memes[(indexPath as NSIndexPath).row]
            cell.lblMemeText.text = meme.topText + " ... " + meme.bottomText
            cell.imageViewMeme.image = meme.memedImage
        }
        return cell
    }
    
    
}
