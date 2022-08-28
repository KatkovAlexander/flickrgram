//
//  Photo.swift
//  testTask
//
//  Created by Александр Катков on 27.08.2022.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    @objc dynamic var photoURL: String = ""
    @objc dynamic var photoDescription: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(photoURL: String, description: String) {
        self.init()
        
        self.photoURL = photoURL
        self.photoDescription = description
    }
    
    init?(json: JSON) {
        guard let photoURL = json["url_q"].string,
              let title = json["title"].string
        else {
            return nil
        }
        
        
        self.photoURL = photoURL
        self.photoDescription = title
    }
}
