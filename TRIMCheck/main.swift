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

let allSATAItems = readSystemProfileSATAItems()
let solidStateSATAItems = allSATAItems.filter({ $0.isSolidState })

if solidStateSATAItems.count <= 0 {
    println("There are no SSD drives")
    exit(0)
}

let solidStateWithoutTRIM = solidStateSATAItems.filter { $0.hasTRIMSupport }

func reportMessageEverywhere(#title : String, #message : String) {
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
    let message = drives + "\nTo resolve, go here: https://gist.github.com/return1/4058659"
    reportMessageEverywhere(title: title, message: message)
}
