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
    
    //MARK: - let/var
    
    var imageKeys = "image"
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
