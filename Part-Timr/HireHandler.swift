//
//  HireHandler.swift
//  Part-Timr for Employer
//
//  Created by Michael V. Corpus on 28/02/2017.
//  Copyright © 2017 Michael V. Corpus. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HireHandler {
    
    private static let _instance = HireHandler()
    
    var employer = ""
    var employee = ""
    var employer_id = ""
    
    static var Instance: HireHandler {
        return _instance
    }
    
    func requestParttimr(latitude: Double, longitude: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: employer, Constants.LATITUDE: latitude, Constants.LONGTITUDE: longitude]
        
            DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
    } //request parttimr
    
    
} // class
