//
//  MemeDetailViewController.swift
//  MemeMe-2.0
//
//  Created by Han Hlaing Moe on 10/08/2021.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    // MARK: Variables/Constants
    var memeIndex: Int!
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add edit button in navigation bar dynamically
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageViewMeme.image = memes[memeIndex].memedImage
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: Private Methods
    
    @objc func editMeme(){
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: Identifier.memeEditor.rawValue) as! MemeEditorViewController
        memeEditorController.memeIndex = memeIndex
        present(memeEditorController, animated: true, completion: nil)
    }
    
}
