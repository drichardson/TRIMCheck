//
//  main.swift
//  TRIMCheck
//
//  Created by Douglas Richardson on 2/4/15.
//  Copyright (c) 2015 Douglas Richardson. All rights reserved.
//
//  Check for TRIM support on your SSD. If it's off,  you may need to follow
//  the instructions here: https://gist.github.com/return1/4058659
//

import Foundation
import Cocoa

NSLog("Getting list of SSD drives from system profile")

let allSATAItems = readSystemProfileSATAItems()
let solidStateSATAItems = allSATAItems.filter({ $0.isSolidState })

if solidStateSATAItems.count <= 0 {
    NSLog("There are no SSD drives")
    exit(0)
}

let solidStateWithoutTRIM = solidStateSATAItems.filter { !$0.hasTRIMSupport }

func reportMessageEverywhere(title title : String, message : String) {
    let textMessage = title + ": " + message
    
    // to NSLog
    NSLog("%@", textMessage)
    
    // To model alert (do this last since it blocks everything else).
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    alert.runModal()
}

if solidStateWithoutTRIM.count > 0 {
    var drives = ""
    for ssd in solidStateWithoutTRIM {
        drives += ssd.name + "\n"
    }
    let title = "Detected SSD drives without TRIM support"
    
    var suggestion : String
    if Int32(floor(NSAppKitVersionNumber)) < NSAppKitVersionNumber10_10_4 {
        suggestion = "To resolve, go here: https://gist.github.com/return1/4058659"
    } else {
        suggestion = "To resolve, run: sudo trimforce enable"
    }
    
    let message = drives + "\n" + suggestion
    reportMessageEverywhere(title: title, message: message)
}
