//
//  ServiceManager.swift
//  APOD
//
//  Created by Vahida on 25/02/22.
//

import Foundation

class ServiceManager
{
        
    public static let shared = ServiceManager()
    
    func GetAPOD<T:Decodable>(urlString : String,success : @escaping((T)->Void), fail:@escaping(()->Void))
    {
        let url = URL(string: urlString)
        
        guard let urlobject = url else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest.init(url: urlobject)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard  error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            print(data)
            
//            let str = String(decoding: data, as: UTF8.self)
//
//            print(str)
            
            let jsondecoder : JSONDecoder = JSONDecoder()
            if let json = try? jsondecoder.decode(T.self, from: data), (json as! APODModel).hdurl != nil
            {
                success(json)
            }
            else
            {
                fail()
            }

        }
        
        
        task.resume()
    }
}

class ApiManager
{
       
    //https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=1995-06-16

    public static let shared = ApiManager()
        
    public var SelectedDate = Date.init()
    
   // let completionHandler ()-> = {}
    
    func retrieveAPOD(success:@escaping((APODModel)-> Void),fail:@escaping(()->Void))
    {
        let baseURL = "https://api.nasa.gov/planetary/apod?"
        let APIKEY = "api_key=gSoNDr2DhZXNFWdXFbAQSWs3ovs7DvLejgF5HUiP"
        
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let selectedDate = "&date=".appending(dateFormatter.string(from: SelectedDate))
        
        ServiceManager.shared.GetAPOD(urlString:baseURL + APIKEY + selectedDate) { (response :APODModel) in
            success(response)
        } fail: {
            fail()
        }



    }
}
