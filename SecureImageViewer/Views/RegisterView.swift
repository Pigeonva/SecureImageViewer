//
//  RegisterView.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 27.09.2022.
//

import UIKit

class RegisterView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: - stataic func
    
    static func instanceFromNib() -> RegisterView {
        return UINib(nibName: "RegisterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RegisterView
    }
    
    //MARK: - IBAction
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.x = -self.frame.width
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}
