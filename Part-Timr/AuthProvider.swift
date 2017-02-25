//
//  AuthProvider.swift
//  Part-Timr for Employer
//
//  Created by Michael V. Corpus on 04/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import Foundation
import Firebase

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let WRONG_PASSWORD = "Wrong password, please try again."
    static let INVALID_EMAIL = "Invalid email address, please provide a real email address."
    static let USER_NOT_FOUND = "User not found, please register"
    static let EMAIL_ALREADY_IN_USE = "Email already in use, please use another email"
    static let WEAK_PASSWORD = "Password should be at least 6 characters long"
    static let PROBLEM_CONNECTING = "Problem connecting to database"
}

class AuthProvider {
    
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider{
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
         
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
        })
        
    }//login
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?)  {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: {(user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                
                if user?.uid != nil {
                    
                    // store the user to database
                    
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                    
                    // login in the user
                    
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)

                }
                
            }
        });
        
        
    } // sign up function
    
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
            
        }
        return true
    } // log out function
    
    
    func handleErrors(err: NSError, loginHandler: LoginHandler?)  {
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            switch errCode {
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            
            
                
            }
        }
    }
    
    
} //AuthProvider
