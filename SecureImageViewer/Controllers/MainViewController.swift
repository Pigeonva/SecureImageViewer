//
//  MainViewController.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 28.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    
    //MARK: - let/var

    var images: [(UIImage, String, Bool)] = []
    var keys = [String]()
    var marker = "" {
        didSet {
            resaveData()
            loadData()
        }
    }
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let savedKeys = UserDefaults.standard.value(forKey: "keys") as? [String] else { return }
        keys = savedKeys
        loadData()
        print(images.count)
    }
    
    //MARK: - IBActions
    
    @IBAction func closeTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoViewerTapped(_ sender: UIButton) {
        if !images.isEmpty {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController else { return }
            controller.images = self.images
            controller.keys = self.keys
            navigationController?.pushViewController(controller, animated: true)
        } else {
            warringAlert(title: "No photos", message: "Add photos")
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as? CreateViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - private methods
    
    private func resaveData() {
        keys = []
        for (image, text, like) in images {
            let randomString = randomString(length: 10)
            self.keys.append(randomString)
            let imageName = saveImage(image: image)
            guard let key = keys.last else { return }
            UserDefaults.standard.set(imageName, forKey: key)
            UserDefaults.standard.set(text, forKey: key + "1")
            UserDefaults.standard.set(like, forKey: key + "2")
            UserDefaults.standard.set(keys, forKey: "keys")
        }
    }
    
    private func loadData() {
        images = []
        for key in keys {
            guard let imageName = UserDefaults.standard.value(forKey: key) as? String else { return }
            guard let text = UserDefaults.standard.value(forKey: key + "1") as? String else { return }
            guard let like = UserDefaults.standard.value(forKey: key + "2") as? Bool else { return }
            guard let image = loadImage(fileName: imageName) else { return }
            images.append((image, text, like))
        }
    }
    
    private func saveImage(image: UIImage) -> String? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
            
            let fileName = UUID().uuidString
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            guard let data = image.jpegData(compressionQuality: 1) else { return nil }
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let error {
                    print("couldn't remove image at path", error)
                }
            }
            
            do {
                try data.write(to: fileURL)
                return fileName
            } catch let error {
                print("error saving data with error", error)
                return nil
            }
        }
    
    private func loadImage(fileName: String) -> UIImage? {
         if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
             let imageURL = documentsDirectory.appendingPathComponent(fileName)
             let image = UIImage(contentsOfFile: imageURL.path)
             return image
         }
         return nil
     }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func warringAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
