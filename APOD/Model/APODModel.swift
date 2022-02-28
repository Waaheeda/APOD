//
//  APODModel.swift
//  APOD
//
//  Created by Vahida on 26/02/22.
//

import Foundation

class APODModel : Decodable
{
    var copyright : String?
    var date : String?
    var explanation : String?
    var hdurl : String?
    var media_type : String?
    var service_version : String?
    var title : String?
    var url : String?
    var isFavourite : Bool?
    var img : Data?

    
}
