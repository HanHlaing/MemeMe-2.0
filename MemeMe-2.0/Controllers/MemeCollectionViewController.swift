//
//  MemeCollectionViewController.swift
//  MemeMe-2.0
//
//  Created by Han Hlaing Moe on 09/08/2021.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Variables/Constants
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderCells(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Reload collection view to update changes
        collectionView!.reloadData()
        // Observe screen rotation changes
        NotificationCenter.default.addObserver(self, selector: #selector(rotateScreen), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    // MARK: Actions
    
    @IBAction func openMemeEditor(_ sender: Any) {
        
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: Identifier.memeEditor.rawValue) as! MemeEditorViewController
        
        // Present the MemeEditorViewController using code
        present(memeEditorController, animated: true, completion: nil)
    }
    
    // MARK: Private methods
    
    // Order cell after getting width and height when roate screen
    @objc func rotateScreen () {
        var width = view.frame.size.width
        var height = view.frame.size.height
        if !(self.isViewLoaded && self.view.window != nil) {
            width = view.frame.size.height
            height = view.frame.size.width
        }
        orderCells(width: width, height: height)
    }
    
    // Make flexible UI for screen orientation
    func orderCells(width: CGFloat, height: CGFloat) {
        let space:CGFloat = 3.0
        var columns:CGFloat = 3.0
        if  width > height {
            columns = 5.0 // landscape
        } else {
            columns = 3.0 // portrait
        }
        let dimension = (width - ((columns - 1) * space)) / columns
        flowLayout.itemSize = CGSize(width: dimension, height: dimension * 0.8)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.memeCollectionCell.rawValue, for: indexPath) as! MemeCollectionViewCell
        
        if !memes.isEmpty {
            let meme = memes[(indexPath as NSIndexPath).row]
            cell.imageViewMeme?.image = meme.memedImage
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: Identifier.memeDetail.rawValue) as! MemeDetailViewController
        memeDetailController.memeIndex = (indexPath as NSIndexPath).row
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
    
}
