//
//  CoreDtataHandler.swift
//  Animation
//
//  Created by Казюка Руслан Сергеевич on 10.01.18.
//  Copyright © 2018 Казюка Руслан Сергеевич. All rights reserved.
//

import UIKit
import CoreData

class CoreDtataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveAnimationModel(animationsArray: [NSDictionary]) {
        
        if self.cleanCoreData() {
        let context = getContext()
        
        for animation in animationsArray {
            let entity = NSEntityDescription.entity(forEntityName: "Animation", in: context)
            let manageObject = NSManagedObject(entity: entity!, insertInto: context)
            let images = animation["images"] as! NSDictionary
            let sizeImage = images["fixed_width_small"] as! NSDictionary
            let image = sizeImage["url"] as! String
            let title = animation["title"] as! String
            let data = NSData.init(contentsOf: NSURL.init(string: image)! as URL)
            manageObject.setValue(data, forKey: "image")
            manageObject.setValue(title, forKey: "title")
           
            do {
                try context.save()
            } catch let error {
               print(error)
            }
        }
      }
    }
    
    class func getAnimationModelFromCoreData() -> [Animation] {
        
        let context = getContext()
        var animationModel:[Animation]!
        do {
            animationModel = try context.fetch(Animation.fetchRequest())
            return animationModel
        } catch {
            return animationModel
        }
    }
    
    class func cleanCoreData() -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Animation.fetchRequest())
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}

