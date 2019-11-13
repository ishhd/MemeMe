//
//  ViewController.swift
//  MemeMe
//
//  Created by Shahad on 07/02/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {

    @IBOutlet weak var ImagePicker: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    
    @IBOutlet weak var share: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        ImagePicker.image = nil
        top.text="TOP"
        bottom.text="BOTTOM"
        dismiss(animated: true, completion: nil)
        
        }
    
    
    
    func textEditor(_ textfield : UITextField){
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold" , size: 40)!,
        NSAttributedString.Key.strokeWidth:-4 ]
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        textfield.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagePicker.isUserInteractionEnabled = true
        textEditor(top)
        textEditor(bottom)
        share.isEnabled = false
        ImagePicker.contentMode = .scaleAspectFit
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        return memedImage
    }
    
    func save() {
        let meme = Meme(topText: top.text ?? "" , bottomText: bottom.text ?? "" , originalImage: ImagePicker.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text
        if textField == top && text == "TOP"{
            top.text = ""
        }else if textField == bottom && text == "BOTTOM"{
            bottom.text = ""
        }
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        let isEmpty = textField.text?.isEmpty ?? true
        if isEmpty && textField == top {
            top.text = "TOP"
        }else if isEmpty && textField == bottom {
            bottom.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func PickAnImage(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        controller.sourceType = (sender.tag == 1) ? .photoLibrary : .camera
        present(controller, animated: true, completion: nil)
        share.isEnabled = true
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.ImagePicker.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: UIButton) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activity, completed , items , error) in if completed {
            self.save()
        
    }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification : Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
}

