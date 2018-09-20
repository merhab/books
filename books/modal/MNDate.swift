//
//  MNDate.swift
//  kotobi
//
//  Created by merhab on 20‏/9‏/2018.
//  Copyright © 2018 merhab. All rights reserved.
//

import Foundation
class MNDate {
    
    static func getTimeStamp()->String{
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
    }
}
