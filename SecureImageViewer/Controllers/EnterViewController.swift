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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    //MARK: - let/var
    
    var user: User?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = UserDefaults.standard.value(User.self, forKey: "user") {
            registerButton.isHidden = true
            nameTextField.isHidden = true
            nameLabel.isHidden = true
            greetingLabel.text = "Hello, ".localize()+"\(user.name)!"
            self.user = user
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greetingLabel.text = "Greetings, Dear Guest!".localize()
    }

    //MARK: - IBActions

    @IBAction func enterTapped(_ sender: UIButton) {
        if user?.password == passwordTextField.text {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            navigationController?.pushViewController(controller, animated: true)
        } else {
            warringAlert(title: "Password incorrect", message: "Try again")
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        if nameTextField.text != "" && passwordTextField.text != "" {
            let user = User(name: nameTextField.text!, password: passwordTextField.text!)
            UserDefaults.standard.set(encodable: user, forKey: "user")
            
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            navigationController?.pushViewController(controller, animated: true)
        } else {
            warringAlert(title: "Error", message: "Fill all lines")
        }
    }
    
    //MARK: - private methods
    
    private func warringAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Extensions

extension EnterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        
        return true
    }
    
    func hideKeyboard() {
        passwordTextField.resignFirstResponder()
    }
}
