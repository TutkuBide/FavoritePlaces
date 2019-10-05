//
//  signInVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 30.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInbut: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let keybordRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(signInVC.hideKeybord) )
        self.view.addGestureRecognizer(keybordRecognizer)
        
        cornerRadius()
        
        
    }
    
    func cornerRadius() {
        imageView.layer.cornerRadius = 75
        signInbut.layer.cornerRadius = 20
        signInbut.clipsToBounds = true
        signInbut.layer.masksToBounds = false
        signInbut.layer.shadowRadius = 10
        signInbut.layer.shadowOpacity = 1.0
        signInbut.layer.shadowOffset = CGSize(width: 3, height: 3)
        signInbut.layer.shadowColor = UIColor.green.cgColor
        signUp.layer.cornerRadius = 20
        signUp.clipsToBounds = true
        signUp.layer.masksToBounds = false
        signUp.layer.shadowRadius = 10
        signUp.layer.shadowOpacity = 1.0
        signUp.layer.shadowOffset = CGSize(width: 3, height: 3)
        signUp.layer.shadowColor = UIColor.green.cgColor
        
        usernameText.layer.cornerRadius = 15.0
        usernameText.layer.borderWidth = 2.0
        passwordText.layer.cornerRadius = 15.0
        passwordText.layer.borderWidth = 2.0
        usernameText.borderStyle = .none
        passwordText.borderStyle = .none
    }
    
    
    @objc func hideKeybord() {
        self.view.endEditing(true) /// klavyeyi kapatır
        
    }
    @IBAction func signIn(_ sender: Any) {
        if usernameText.text != nil && passwordText.text != nil{
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(self.usernameText.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberuser()
                }
            }
        }else{
            let alert = UIAlertController(title: "Hata", message: "hataloı", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
            
            
        }
    
    
    @IBAction func signup(_ sender: Any) {
        if usernameText.text != nil && passwordText.text != nil {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(self.usernameText.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberuser()
                }
            }
        }else{
            let alert = UIAlertController(title: "Hata", message: "hataloı", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
      
       
        
    }
    
    
}
