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
    func parttimrAcceptedRequest(requestAccepted: Bool, parttimrName: String)
    func updateParttimrsLocation(lat: Double, long: Double)
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
        
        // PARTTIMR ACCEPTED
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childAdded) { (Snapshot:FIRDataSnapshot) in
            
            if let data = Snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if self.employee == "" {
                        self.employee = name;
                        self.delegate?.parttimrAcceptedRequest(requestAccepted: true, parttimrName: self.employee)
                    }
                }
            }
            
        }
        
        // PARTTIMR CANCELED
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childRemoved) { (snapshot:FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.employee {
                        self.employee = ""
                        self.delegate?.parttimrAcceptedRequest(requestAccepted: false, parttimrName: name);
                    }
                }
            }
            
        }
        
        // PARTTIMR UPDATING LOCATION
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childChanged) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.employee {
                        if let lat = data[Constants.LATITUDE] as? Double {
                            if let long = data[Constants.LONGTITUDE] as? Double {
                                self.delegate?.updateParttimrsLocation(lat: lat, long: long)
                            }
                        }
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
    
    func updateParttimrsLocation(lat: Double, long: Double) {
        DBProvider.Instance.requestRef.child(employer_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGTITUDE: long]);
    }
    
    
} // class
