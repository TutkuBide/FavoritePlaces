//
//  imagesVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 28.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
var globalName = ""
var globalType = ""
var globalAtmospher = ""
var globalImage = UIImage()

class imagesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var nextButtons: UIBarButtonItem!
    @IBOutlet weak var placenameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmospherText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radius()
        nextButtons.isEnabled = false
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imagesVC.selectedImage))
        imageView.addGestureRecognizer(recognizer)
    }
    
    func radius() {
        placenameText.layer.cornerRadius = 75
        placeTypeText.layer.cornerRadius = 75
        placeAtmospherText.layer.cornerRadius = 75
    }

    override func viewWillAppear(_ animated: Bool) {
        globalName = ""
        globalType = ""
        globalAtmospher = ""
        globalImage = UIImage()
        
    }
    
    @objc func selectedImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        nextButtons.isEnabled = true
    }
    
    @IBAction func nextClick(_ sender: Any) {
       nextButtons.isEnabled = false
        if placenameText.text != nil && placeTypeText.text != nil && placeAtmospherText.text != nil {
            if let chosenImage = imageView.image {
                globalName = placenameText.text!
                globalType = placeTypeText.text!
                globalAtmospher = placeAtmospherText.text!
                globalImage = chosenImage
            }
        }
        self.performSegue(withIdentifier: "fromimageVCtomapVC", sender: nil)
        placenameText.text = ""
        placeTypeText.text = ""
        placeAtmospherText.text = ""
        imageView.image = UIImage(named: "Unknown.png")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
