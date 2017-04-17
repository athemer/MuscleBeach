//
//  CoreDataManager.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/17.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    
    // swiftlint:disable:next force_cast
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:disable:previous force_cast
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "userMO")
    
    let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: true)
    
    
//    
//    func createCoreData(name: String, addressMain: String, addressDetail: String, deliver: String, prefA: Int, prefB: Int, prefC: Int, profileImage: NSData, email: String, number: String) {
//        
//        let moc = appDelegate.persistentContainer.viewContext
//        
//        let userMO = UserMO(context: moc)
//        
//        userMO.name = name
//        userMO.addressMain = addressMain
//        userMO.addressDetail = addressDetail
//        userMO.deliver = deliver
//        userMO.prefA = Int16(prefA)
//        userMO.prefB = Int16(prefB)
//        userMO.prefC = Int16(prefC)
//        userMO.profileImage = profileImage
//        userMO.email = email
//        userMO.number = number
//        
//    }
    
    func readCoreData(id: NSManagedObjectID) -> UserMO? {
        
        let moc = appDelegate.persistentContainer.viewContext
        
        let results = try? moc.existingObject(with: id)
        
        return results as? UserMO
    }
    
    
    
    
//    func update(row: Int, title: String?, content: String?) {
//        
//        let moc = appDelegate.persistentContainer.viewContext
//        
//        request.sortDescriptors = [sortDescriptor]
//        
//        do {
//            
//            guard let results = try moc.fetch(request) as? [UserMO] else {
//                return
//            }
//            
//            let userInfo = results[row]
//            
//            if let title = title {
//                article.title = title
//            }
//            
//            if let content = content {
//                article.content = content
//            }
//            
//        } catch {
//            
//            fatalError("\(error)")
//        }
//        
//    }

    
    
    
    
    func delete(id: NSManagedObjectID) {
        
        let moc = appDelegate.persistentContainer.viewContext
        
        do {
            
            let userInfo = try moc.existingObject(with: id)
            
            moc.delete(userInfo)
            
        } catch {
            
            fatalError("\(error)")
        }
        
    }
    
    
    func deleteAll() {
        
        
        let moc = appDelegate.persistentContainer.viewContext
        
        do {
            
            guard let results = try moc.fetch(request) as? [UserMO] else {
                return
            }
            
            for result in results {
                
                moc.delete(result)
            }

            appDelegate.saveContext()
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
        
    }
    
}

