//
//  SignInVC.swift
//  Part-Timr
//
//  Created by Michael V. Corpus on 31/01/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    private let EMPLOYER_SEGUE = "EmployerVC"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Next button from email textfield to password textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Authentication Error", message: message!)
                    
                } else {
                    
                    HireHandler.Instance.hirer = self.emailTextField.text!
                    
                    self.passwordTextField.text = ""; //clears the password field
                    
                    self.performSegue(withIdentifier: self.EMPLOYER_SEGUE, sender: nil)
                    print("LOGIN SUCCESSFUL")
                    
                }
            
            })
            
        } else {
            let alertTheUser = UIAlertController(title: "Error", message: "Username and Password cannot be left empty.", preferredStyle: .alert)
            alertTheUser.addAction(UIAlertAction(title: "OK", style:. default, handler: nil))
            present(alertTheUser, animated:true, completion: nil)
        }
    }
    
    func  alertTheUser(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction (UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
    }
  
    
    @IBAction func signupButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
              
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!)
                } else {
                    print("CREATING A NEW USER COMPLETE")
                    self.performSegue(withIdentifier: self.EMPLOYER_SEGUE, sender: nil)
                    //self.alertTheUser(title: "Signing In Complete", message: "Creating the user successful")
                    
                }
                
            })
            
        } else {
            let alertTheUser = UIAlertController(title: "Error", message: "Username and Password cannot be left empty.", preferredStyle: .alert)
            alertTheUser.addAction(UIAlertAction(title: "OK", style:. default, handler: nil))
            present(alertTheUser, animated:true, completion: nil)
        }
        
    }
  
    
}
