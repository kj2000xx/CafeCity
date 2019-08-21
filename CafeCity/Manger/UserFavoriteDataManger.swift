//
//  UserFavoriteDataManger.swift
//  CafeCity
//
//  Created by Shane on 2019/8/21.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import UIKit


enum FileName: String {
    case userData
}

enum FileKey: String {
    case favorIdList
}
//向指定的plist中写入数据--fileName:  text.plist
class UserDataManager: NSObject {
    
    //寫入
    /* 範例
    class func saveData(fileKey: FileKey, value: Any, fileName: FileName) -> () {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName.rawValue)
        let dict: NSMutableDictionary = NSMutableDictionary()

        dict.setValue(value, forKey: fileKey.rawValue)
        dict.write(toFile: path, atomically: true)
        
    }
    */
    
    //讀取
    /* 範例
    class func researchData(filekey: FileKey, fileName: FileName) -> Any {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName.rawValue)
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: fileName.rawValue, ofType: nil) {
                try! fileManager.copyItem(atPath: bundlePath, toPath: path)
            } else {
                print(fileName.rawValue + " not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print(fileName.rawValue + " already exits at path.")
        }
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            return dict.object(forKey: filekey.rawValue) ?? ""
        } else {
            print("WARNING: Couldn't create dictionary from " + filekey.rawValue + "! Default values will be used!")
            return ""
        }
    }
    */
    
    class func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        
        return documentsDirectory
    }
    
    class func saveFavorIdListDataData(fileKey: FileKey, value: Array<String>, fileName: FileName) -> () {
        
        let documentsDirectory = self.documentsDirectory()
        let path = documentsDirectory.appendingPathComponent(fileName.rawValue)
        let dict: NSMutableDictionary = NSMutableDictionary()
        
        dict.setValue(value, forKey: fileKey.rawValue)
        dict.write(toFile: path, atomically: true)
        
    }
    
    
    class func loadFavorIdListData() -> Array<String>?{
        let filekey = FileKey.favorIdList.rawValue
        let fileName = FileName.userData.rawValue
        
        let documentsDirectory = self.documentsDirectory()
        let path = documentsDirectory.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)) {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: nil) {
                try! fileManager.copyItem(atPath: bundlePath, toPath: path)
            } else {
                print(fileName + " not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print(fileName + " already exits at path.")
        }
        let myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            return (dict.object(forKey: filekey) as! Array<String>)
        } else {
            print("WARNING: Couldn't create dictionary from " + filekey + "! Default values will be used!")
            return nil
        }

        
        
    }
    
}
