//
//  PhotoValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import CloudKit
import RealmSwift

extension PhotoValue: CloudKitSyncable {
    func record(zoneID: CKRecordZone.ID) -> CKRecord? {
        let recordId = CKRecord.ID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "PhotoValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        // Photo
        record.setObject(self.latitude as CKRecordValue, forKey: "latitude")
        record.setObject(self.longitude as CKRecordValue, forKey: "longitude")
        if let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ee.chippstudio.evaluateday")?.path {
            let imagePath = documentPath.appending("/media").appending("/\(self.id).png")
            let url = URL(fileURLWithPath: imagePath)
            let photoAsset = CKAsset(fileURL: url)
            record.setObject(photoAsset, forKey: "photo")
        }
        return record
    }
    
    static func object(record: CKRecord) -> PhotoValue? {
        let photoValue = PhotoValue()
        photoValue.id = record.recordID.recordName
        photoValue.owner = record.object(forKey: "owner") as! String
        photoValue.created = record.object(forKey: "created") as! Date
        photoValue.edited = record.object(forKey: "edited") as! Date
        // photo
        photoValue.latitude = record.object(forKey: "latitude") as! Double
        photoValue.longitude = record.object(forKey: "longitude") as! Double
        let photoAsset = record.object(forKey: "photo") as! CKAsset
        if let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ee.chippstudio.evaluateday")?.path {
            let imagePath = documentPath.appending("/media").appending("/\(photoValue.id)")
            let url = URL(fileURLWithPath: imagePath)
            do {
                try FileManager.default.copyItem(at: photoAsset.fileURL!, to: url)
            } catch let error {
                print("Copy image went wrong - \(error.localizedDescription)")
            }
        }
        return photoValue
    }
    
    typealias CloudKitSyncable = PhotoValue
}

extension PhotoValue {
    var image: UIImage {
        get {
            if let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ee.chippstudio.evaluateday")?.path {
                // Custom folder path
                let mediaPath = documentPath.appending("/media")
                let imagePath = mediaPath.appending("/\(self.id).png")
                if let image = UIImage(contentsOfFile: imagePath) {
                    return image
                }
            }
            
            return #imageLiteral(resourceName: "selectPhoto")
        }
        
        set {
            var newRect: CGRect!
            
            let maxSize: CGFloat = 800.0
            if newValue.size.width > newValue.size.height {
                let scale = maxSize / newValue.size.width
                let newHeight = newValue.size.height * scale
                
                newRect = CGRect(x: 0.0, y: 0.0, width: maxSize, height: newHeight)
            } else {
                let scale = maxSize / newValue.size.height
                let newWidth = newValue.size.width * scale
                
                newRect = CGRect(x: 0.0, y: 0.0, width: newWidth, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(newRect.size)
            newValue.draw(in: newRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageData = newImage!.pngData()
            if let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ee.chippstudio.evaluateday")?.path {
                let fullPath = documentPath.appending("/media").appending("/\(self.id).png")
                do {
                    try imageData?.write(to: URL(fileURLWithPath: fullPath))
                } catch {
                    print("can not save image to Documents folder")
                }
            }
        }
    }
}
