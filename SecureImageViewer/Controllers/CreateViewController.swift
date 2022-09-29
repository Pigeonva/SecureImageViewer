//
//  CreateViewController.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 28.09.2022.
//

import UIKit

class CreateViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - let/var
    
    var imageKeys = "image"
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        registerForKeyboardNotifications()
        callPickerView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: - IBActions
    
    @IBAction func imageTapped() {
        callPickerView()
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        if imageView.image != nil && textField.text != nil && textField.text != "" {
            
            guard let previousVC = navigationController?.viewControllers[1] as? MainViewController else { return }
            previousVC.images.append((imageView.image!, textField.text!, false))
            previousVC.marker += "1"
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Private methods
    
    private func callPickerView() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
            guard let userInfo = notification.userInfo,
                  let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                  let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                bottomConstraint.constant = 0
            } else {
                bottomConstraint.constant = keyboardScreenEndFrame.height + 10
            }
            
            view.needsUpdateConstraints()
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
}

//MARK: - Extensions

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = UIImage()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }
        imageView.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
