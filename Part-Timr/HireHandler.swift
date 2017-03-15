//
//  HireHandler.swift
//  Part-Timr for Employer
//
//  Created by Michael V. Corpus on 28/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ParttimrController: class {
    func canCallParttimr(delegateCalled: Bool)
}

class HireHandler {
    
    private static let _instance = HireHandler()
    
    weak var delegate: ParttimrController?
    
    var employer = ""
    var employee = ""
    var employer_id = ""
    
    static var Instance: HireHandler {
        return _instance
    }
    
    func observeMessagesForEmployer() {
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.employer {
                        self.employer_id = snapshot.key
                        print("The value is \(self.employer_id)")
                        self.delegate?.canCallParttimr(delegateCalled: true)
                    }
                }
            }
        }
        
        
        //Canceled Parttimr
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childRemoved) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.employer {
                        self.delegate?.canCallParttimr(delegateCalled: false)
                    }
                }
            }
        }
    }
    
    func requestParttimr(latitude: Double, longitude: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: employer, Constants.LATITUDE: latitude, Constants.LONGTITUDE: longitude]
        
            DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
    } //request parttimr
    
    func cancelParttimr() {
        DBProvider.Instance.requestRef.child(employer_id).removeValue()
    }
    
    
} // class
