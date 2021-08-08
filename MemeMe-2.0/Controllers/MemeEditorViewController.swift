//
//  MemeEditorViewController.swift
//  MemeMe-2.0
//
//  Created by Han Hlaing Moe on 08/08/2021.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    // MARK: Variables/Constants
    
    //private var imageMeme: UIImage?
    private var fontName = "Impact"
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnShare.isEnabled = false
        setUpText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: UIImagePickerController.SourceType.camera)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
        let imageMeme = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [imageMeme], applicationActivities: nil)
        activityController.isModalInPresentation = true
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed == true {
                print("Service completed successfully")
                self.save(imageMeme)
                self.dismiss(animated: true, completion: nil)
            }else {
                print("Service was cancelled")
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    // Setup default views after tap the cancel buttons
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        btnShare.isEnabled = false
        setUpText()
    }
    
    @IBAction func changeFontStyle(_ sender: Any) {
        showFontActionSheet()
    }
    
    //MARK: Private methods
    
    // Generate the meme image by UI Graphics Image Context
    func generateMemedImage() -> UIImage {
        hideToolbarAndNavigationBar(hidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbarAndNavigationBar(hidden: false)
        
        return memedImage
    }
    
    // Save the meme struct
    func save(_ memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // The action sheet dialog for change the font
    func showFontActionSheet() {
        
        let alertController = UIAlertController(title: "Choose Font Style",
                                                message: "Please choose your desire font",
                                                preferredStyle: .actionSheet)
        
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                let fontAction = UIAlertAction(title: font,
                                               style: .default) { _ in
                    self.fontName = font
                    self.setUpText()
                    
                }
                
                alertController.addAction(fontAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Setup the two text fields
    func setUpText() {
        
        setupTextField(textFieldTop, text: "TOP")
        setupTextField(textFieldBottom, text: "BOTTOM")
    }
    
    // Setup the text field with attributes
    private func setupTextField(_ textField: UITextField, text: String) {
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: fontName, size: 40) ?? UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -2.0
        ]
        
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func hideToolbarAndNavigationBar(hidden: Bool) {
        toolbar.isHidden = hidden
        navigationBar.isHidden = hidden
    }
    
    
    // Pick the image based on source
    private func pickAnImage(source: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    // Add the notification observer and call this when controller appears
    func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Remove the notification observer and call this when controller disappears
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    // Set the view origin y after showing keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if textFieldBottom.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Set the view origin y after hiding keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // Getting the keyboard hight
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
