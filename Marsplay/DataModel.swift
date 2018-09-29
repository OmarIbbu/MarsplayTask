//
//  DataModel.swift
//  Marsplay
//
//  Created by thincnext on 28/09/18.
//  Copyright © 2018 thincnext. All rights reserved.
//

import Foundation

class DataModel {
    var Title : String
    var Year : String
    var imdbID : String
    var type : String
    var Poster : String
    
    init(Title: String, Year:String,imdbID:String,type:String,Poster:String) {
        self.Title = Title
        self.Year = Year
        self.imdbID = imdbID
        self.type = type
        self.Poster = Poster
    }

}
