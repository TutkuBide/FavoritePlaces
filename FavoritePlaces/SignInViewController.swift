//
//  signInVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 30.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keybordRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(SignInViewController.hideKeybord) )
        self.view.addGestureRecognizer(keybordRecognizer)
        setupUI()
    }
    
    func setupUI() {
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        signInButton.layer.masksToBounds = false
        signUpButton.layer.cornerRadius = 20
        signUpButton.clipsToBounds = true
        signUpButton.layer.masksToBounds = false
        usernameTextField.layer.cornerRadius = 15.0
        usernameTextField.layer.borderWidth = 2.0
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 2.0
        usernameTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
    }
    
    @objc func hideKeybord() {
        self.view.endEditing(true)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if usernameTextField.text != nil && passwordTextField.text != nil{
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(self.usernameTextField.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            }
        }else{
            let alert = UIAlertController(title: "Hata", message: "hataloı", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if usernameTextField.text != nil && passwordTextField.text != nil {
            let user = PFUser()
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            user.signUpInBackground { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(self.usernameTextField.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
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
