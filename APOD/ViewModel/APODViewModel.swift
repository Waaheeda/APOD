//
//  APODViewModel.swift
//  APOD
//
//  Created by Vahida on 26/02/22.
//

import Foundation
import UIKit

class APODViewModel : NSObject
{
    var userCacheURL: URL?
       
    let userCacheQueue = OperationQueue()
    
    let cache = NSCache<NSString, APODModel>()
    
    
    private(set) var apodData : APODModel! {
        didSet {
            
            self.bindAPODViewModelToController()
        }
    }
    
    var bindAPODViewModelToController : (() -> ()) = {
        
    }
    
    var completion : (() -> ()) = {
        
    }
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    
    override init()
    {
        
        super.init()
        
        
//        container = NSPersistentContainer(name: "APOD")
//
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error {
//                print("Unresolved error \(error)")
//            }
//        }
        
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.userCacheURL = cacheURL.appendingPathComponent("apod.json")
               }
        
        DispatchQueue.main.async {
          
            do {
                if !self.checkInternet()
                {
                    //read from cache
//                            self.userCacheQueue.addOperation() {
//                                                    if let stream = InputStream(url: self.userCacheURL!) {
//                                                        stream.open()
//
//                                                        let data = (try? JSONSerialization.jsonObject(with: stream, options: [])) as! [String:Any]
//
//
//
//                                                        stream.close()
//                                                    }
//
//                            // Update the UI
//                            OperationQueue.main.addOperation() {
//                                self.bindAPODViewModelToController()
//                            }
//                        }
                }
                else
                {
                    ApiManager.shared.retrieveAPOD(success: { (response : APODModel) in
                        
                        if response.media_type == "image"
                        {
                            self.apodData = response
                            do {
                                self.apodData.img = try Data.init(contentsOf: URL.init(string: (self.apodData.hdurl!))!)
                                self.bindAPODViewModelToController()

                            } catch  {
                                print("Failed to load image")

                            }
                            //
                            // Write the response to the cache
//                            if (self.userCacheURL != nil) {
//                                                    self.userCacheQueue.addOperation() {
//                                                        if let stream = OutputStream(url: self.userCacheURL!, append: false) {
//                                                            stream.open()
//
//                                                            JSONSerialization.writeJSONObject(response, to: stream, options: [.prettyPrinted], error: nil)
//
//                                                            stream.close()
//                                                        }
//                                                    }
//                                                }
                           

                        }
                    }, fail: {
                        print("Failed")
                        self.completion()
                    })
                }
                
            }catch let error as NSError
            {
                print("Could not fetch. \(error), \(error.userInfo)")
                
            }
            
        }
        
    }
    
    func SaveFavourite(apodDataModel : APODModel)
    {
     
        DBHelper.shared.saveFavourite(apodData: apodDataModel)
        
    }
    
    // MARK:
    func checkInternet() -> Bool
    {
        let scriptUrl = URL.init(string: "https://www.google.com/")
        let data = NSData.init(contentsOf: scriptUrl!)
        if (data != nil)
        {
            print("Device is connected to the Internet")
            return true
        }
        else
        {
            print("Device is not connected to the Internet")
            return false
        }
    }
}
