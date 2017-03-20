//
//  HireHandler.swift
//  Part-Timr for hirer
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
    
    var hirer = ""
    var parttimr = ""
    var hirer_id = ""
    
    static var Instance: HireHandler {
        return _instance
    }
    
    func observeMessagesForHirer() {
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.hirer {
                        self.hirer_id = snapshot.key
                        print("The value is \(self.hirer_id)")
                        self.delegate?.canCallParttimr(delegateCalled: true)
                    }
                }
            }
        }
        
        
        //Canceled Parttimr
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childRemoved) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.hirer {
                        self.delegate?.canCallParttimr(delegateCalled: false)
                    }
                }
            }
        }
        
        // PARTTIMR ACCEPTED
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childAdded) { (Snapshot:FIRDataSnapshot) in
            
            if let data = Snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if self.parttimr == "" {
                        self.parttimr = name;
                        self.delegate?.parttimrAcceptedRequest(requestAccepted: true, parttimrName: self.parttimr)
                    }
                }
            }
            
        }
        
        // PARTTIMR CANCELED
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childRemoved) { (snapshot:FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.parttimr {
                        self.parttimr = ""
                        self.delegate?.parttimrAcceptedRequest(requestAccepted: false, parttimrName: name);
                    }
                }
            }
            
        }
        
        // PARTTIMR UPDATING LOCATION
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childChanged) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.parttimr {
                        if let lat = data[Constants.LATITUDE] as? Double {
                            if let long = data[Constants.LONGITUDE] as? Double {
                                self.delegate?.updateParttimrsLocation(lat: lat, long: long)
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    func requestParttimr(latitude: Double, longitude: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: hirer, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        
            DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
    } //request parttimr
    
    func cancelParttimr() {
        DBProvider.Instance.requestRef.child(hirer_id).removeValue()
    }
    
    func updateParttimrsLocation(lat: Double, long: Double) {
        DBProvider.Instance.requestRef.child(hirer_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long]);
    }
    
    
} // class
