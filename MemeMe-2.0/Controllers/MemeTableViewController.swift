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
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload table view to update changes
        tableView!.reloadData()
        // Set table view row height
        tableView!.rowHeight = 100
    }
    
    // MARK: Actions
    
    @IBAction func openMemeEditor(_ sender: Any) {
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: Identifier.memeEditor.rawValue) as! MemeEditorViewController
        // Present the MemeEditorViewController using code
        present(memeEditorController, animated: true, completion: nil)
    }
    
    // MARK: TableViewController Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.memeTableCell.rawValue) as! MemeTableViewCell
        if !memes.isEmpty {
            let meme = memes[(indexPath as NSIndexPath).row]
            cell.lblMemeText.text = meme.topText + " ... " + meme.bottomText
            cell.imageViewMeme.image = meme.memedImage
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard!.instantiateViewController(withIdentifier: Identifier.memeDetail.rawValue) as! MemeDetailViewController
        memeDetailViewController.memeIndex = (indexPath as NSIndexPath).row
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
}
