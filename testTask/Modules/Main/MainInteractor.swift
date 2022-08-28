//
//  MainInteractor.swift
//  testTask
//
//  Created by Александр Катков on 25.08.2022.
//

import Foundation
import RxAlamofire
import RxSwift
import RealmSwift

protocol MainInteractorInput: AnyObject {
    
    var photos: [Photo] { get }
    
    func loadPhotos()
    
    func fetchPhotos()
}

final class MainInteractor: MainInteractorInput {
    
    var presenter: MainPresenterInput?
    
    var photos: [Photo] {
        var photosFromStorage: [Photo] = []
        for photo in realm.objects(Photo.self) {
            photosFromStorage.append(Photo(photoURL: photo.photoURL,
                                           description: photo.photoDescription))
        }
    
        return photosFromStorage
    }
    
    // MARK: Private properties
    
    private let realm = try! Realm()
    private let bag = DisposeBag()
    
    // MARK: - Implementation
    
    func loadPhotos() {
        print(#fileID, #function)
        
        if photos.isEmpty {
            fetchPhotos()
        } else {
            presenter?.onSuccess(data: nil,
                                 storageType: .iphoneStorage)
        }
    }
    
    func fetchPhotos() {
        print(#fileID, #function)
        
        let items = realm.objects(Photo.self)
        try! realm.write {
            realm.delete(items)
        }
        
        for category in Service.photoCategories {
            fetchPhoto(category: category)
        }
    }
    
    
    func fetchPhoto(category: String) {
        print(#fileID, #function)
        
        request(.get, Service.url, parameters: Service.getParametrs(category: category))
            .observeOn(MainScheduler.asyncInstance)
            .asSingle()
            .subscribe(onSuccess: { [weak presenter] response in
                guard let data = response.data else {
                    presenter?.onError(error: "error while parsing response")
                    return
                }
                
                presenter?.onSuccess(data: data,
                                     storageType: .internet)
            }, onError: { [weak presenter] error in
                presenter?.onError(error: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
