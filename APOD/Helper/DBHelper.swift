//
//  DBHelper.swift
//  APOD
//
//  Created by Vahida on 28/02/22.
//

import Foundation
import UIKit
import CoreData

class DBHelper
{
    public static  let shared = DBHelper()
    
    private init()
    {
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func resetAllFavourites()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "APODEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDelegate.persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Could not delete all. \(error), \(error.userInfo)")
        }
    }
    
//    func fetchAPOD() -> APODModel
//    {
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APODEntity")
//        do {
//            let fetchingAPOD = try context.fetch(fetchRequest)
//            return fetchingAPOD.first as APODModel
//        } catch {
//            print("Error while fetching the APOD")
//        }
//        return APODModel()
//    }
    
    func saveFavourite(apodData : APODModel)
    {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            
            // 1
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // 2
            let entity = NSEntityDescription.entity(forEntityName: "APODEntity",
                                                    in: managedContext)!
            
            do {
                
                let request = NSFetchRequest<NSFetchRequestResult>()
                request.entity = entity
                
                let predicate = NSPredicate(format: "(date = %@)", apodData.date!)
                request.predicate = predicate
                do {
                    let results = try managedContext.fetch(request)
                    if !results.isEmpty
                    {
                        if let objectUpdate = results[0] as? NSManagedObject
                        {
                            objectUpdate.setValue(apodData.isFavourite, forKey: "isFavourite")
                        }
                        
                    }
                    else
                    {
                        // 3
                        
                        let apod  = NSManagedObject(entity: entity,
                                                    insertInto: managedContext)
                                                
                        apod.setValue(apodData.copyright, forKeyPath: "copyright")
                        apod.setValue(apodData.date, forKeyPath: "date")
                        apod.setValue(apodData.explanation, forKeyPath: "explanation")
                        apod.setValue(apodData.hdurl, forKeyPath: "hdurl")
                        apod.setValue(apodData.media_type, forKeyPath: "media_type")
                        apod.setValue(apodData.service_version, forKeyPath: "service_version")
                        apod.setValue(apodData.title, forKeyPath: "title")
                        apod.setValue(apodData.url, forKeyPath: "url")
                        apod.setValue(apodData.isFavourite, forKeyPath: "isFavourite")
                        apod.setValue(Date(), forKey: "modifiedDateTime")
                            
                        do {
                             let data =  try Data.init(contentsOf: URL.init(string: (apodData.hdurl!))!)
                            apod.setValue(data, forKey: "img")

                        } catch  {
                            print("Could not save image")
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print(error.description)
                }
                // 4
                
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func saveImage(data: Data) {
        let imageInstance = APODEntity(context: context)
        imageInstance.img = data
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
