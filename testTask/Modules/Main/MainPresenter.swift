//
//  MainPresenter.swift
//  testTask
//
//  Created by Александр Катков on 25.08.2022.
//

import Foundation
import SwiftyJSON
import RealmSwift

protocol MainPresenterInput: AnyObject {
    
    func onSuccess(data: Data?, storageType: StorageType)
    
    func onError(error: String)
}

final class MainPresenter {
    
    var view: MainViewControllerInput?
    
    // MARK: Private properties
    
    private let realm = try! Realm()
}

extension MainPresenter: MainPresenterInput {
    
    func onSuccess(data: Data?, storageType: StorageType) {
        print(#fileID, #function)
        
        if let data = data {
            guard let json = try? JSON(data: data) else {
                onError(error: "error while parsing response")
                return
            }
            
            let photosJSON = json["photos"]["photo"]
            let photos = photosJSON.arrayValue.compactMap { Photo(json: $0)}
            
            guard photos.count > 0 else {
                onError(error: "no photos for this request")
                return
            }
            let photo = photos[Int.random(in: 0..<photos.count)]
            
            realm.beginWrite()
            realm.add(photo)
            try! realm.commitWrite()
            print("\(photo) was saved to iPhone")
        }
        
        view?.photoDidLoad(storageType: storageType.rawValue)
    }
    
    func onError(error: String) {
        print(#fileID, #function)
        
        fatalError(error)
    }
}
