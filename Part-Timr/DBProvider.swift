//
//  DBProvider.swift
//  Part-Timr for Employer
//
//  Created by Michael V. Corpus on 16/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.PARTTIMR_REQUEST)
    }
    
    var hirerRef: FIRDatabaseReference {
        return dbRef.child(Constants.HIRER)
    }
    
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.PARTTIMR_ACCEPTED)
    }
    
    func saveUser(withID: String, email: String, password: String)  {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isHirer: true]
        
        hirerRef.child(withID).child(Constants.DATA).setValue(data)
        
    }
    
    
}
