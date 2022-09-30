//
//  PhotosViewController.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 28.09.2022.
//

import UIKit

class PhotosViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - let/var
    
    var images = [(UIImage, String, Bool)]()
    var keys = [String]()
    var secondImageView = UIImageView()
    let space: CGFloat = 20
    var index = 0
    var marker = 0 {
        didSet {
            likeButton.isSelected = images[index].2
        }
    }
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        textField.delegate = self
        imageView.image = images[index].0
        textField.text = images[index].1
        likeButton.isSelected = images[index].2
        
        secondImageView.contentMode = .scaleAspectFit
    }
    
    //MARK: - IBActions
    
    @IBAction func likeTapped(_ sender: UIButton) {
        images[index].2 = !images[index].2
        UserDefaults.standard.set(images[index].2, forKey: keys[index] + "2")
        marker += 1
    }
    
    @IBAction func leftTapped(_ sender: UIButton) {
        if index == 0 {
            index = images.count - 1
            leftMove()
        } else {
            index -= 1
            leftMove()
        }
    }
    
    @IBAction func rightTapped(_ sender: UIButton) {
        if index < images.count - 1 {
            index += 1
            self.rightMove()
        } else {
            index = 0
            self.rightMove()
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private methods
    
    private func rightMove() {
        view.addSubview(secondImageView)
        secondImageView.frame = CGRect(x: self.view.frame.width, y: imageView.frame.origin.y, width: imageView.frame.width, height: imageView.frame.height)
        let image = images[index].0
        let text = images[index].1
        marker += 1
        textField.text = text
        secondImageView.image = image
        UIView.animate(withDuration: 0.3) {
            self.secondImageView.frame.origin.x -= self.imageView.frame.width + self.space
        } completion: { _ in
            self.imageView.image = self.secondImageView.image
            self.secondImageView.removeFromSuperview()
        }
    }
    
    private func leftMove() {
        view.addSubview(secondImageView)
        secondImageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: imageView.frame.width, height: imageView.frame.height)
        secondImageView.image = imageView.image
        imageView.image = images[index].0
        let text = images[index].1
        marker += 1
        textField.text = text
        UIView.animate(withDuration: 0.3) {
            self.secondImageView.frame.origin.x -= self.imageView.frame.width
        } completion: { _ in
            self.secondImageView.removeFromSuperview()
        }
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

extension PhotosViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            UserDefaults.standard.set(text, forKey: keys[index] + "1")
            images[index].1 = text
        }
        textField.resignFirstResponder()
        return true
    }
    
}
