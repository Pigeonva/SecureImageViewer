//
//  EnterViewController.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 27.09.2022.
//

import UIKit

class EnterViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: - let/var
    
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - IBActions

    @IBAction func enterTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let registerView = RegisterView.instanceFromNib()
        registerView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(registerView)
        
        UIView.animate(withDuration: 0.3) {
            registerView.frame.origin.x = 0
        }
    }
    
    //MARK: - private methods
    
    
    
}

