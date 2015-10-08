//
//  system_profile.swift
//  TRIMCheck
//
//  Created by Douglas Richardson on 2/4/15.
//  Copyright (c) 2015 Douglas Richardson. All rights reserved.
//

import Foundation

struct SATAItem
{
    let name : String
    let model : String
    let hasTRIMSupport : Bool
    let isSolidState : Bool
    let isRemovableMedia : Bool
}

func readSystemProfileSATAItems() -> [SATAItem] {
    var result : [SATAItem] = []
    //            if let dict = ((array[0] as? NSDictionary)["_items"] as? NSArray) {
    //              if let items = dict["_items"] as? NSArray {
    //                for item in items {
    
    if let array = ((readSystemProfileArray()?[0] as? NSDictionary)?["_items"] as? NSArray) {
        for item in array {
            if let d = (((item as? NSDictionary)?["_items"] as? NSArray)?[0] as? NSDictionary) {
                let name = (d["_name"] as? String) ?? "NONAME"
                let model = (d["device_model"] as? String) ?? "NOMODEL"
                let hasTRIMSupport = ((d["spsata_trim_support"] as? String) ?? "NO").uppercaseString == "YES"
                let medium = (d["spsata_medium_type"] as? String) ?? "NOMEDIUM"
                let isSolidState = medium.uppercaseString == "SOLID STATE"
                let isRemovableMedia = ((d["removable_media"] as? String) ?? "NO").uppercaseString == "YES"
                result.append(SATAItem(name: name,
                    model: model,
                    hasTRIMSupport: hasTRIMSupport,
                    isSolidState: isSolidState,
                    isRemovableMedia: isRemovableMedia))
            }
        }
    }
    
    return result
}

private func readSystemProfileArray() -> NSArray? {
    let out = NSPipe()
    let task = NSTask()
    task.launchPath = "/usr/sbin/system_profiler"
    task.arguments = ["-xml", "SPSerialATADataType"]
    task.standardOutput = out
    task.launch()
    task.waitUntilExit()
    
    if task.terminationStatus != 0 {
        NSLog("system_profiler returned error status")
        return nil
    }
    
    let data = out.fileHandleForReading.readDataToEndOfFile()
    let plist : AnyObject?
    do {
        plist = try NSPropertyListSerialization.propertyListWithData(data,
                options: [.Immutable],
                format: nil)
    } catch let error as NSError {
        NSLog("%@", "Failed to parse system_profiler results. \(error.localizedDescription)")
        return nil
    }
    
    return plist as? NSArray
}