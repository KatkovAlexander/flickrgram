//
//  MainViewController.swift
//  testTask
//
//  Created by Александр Катков on 25.08.2022.
//

import UIKit
import MBProgressHUD

protocol MainViewControllerInput: AnyObject {
    
    func photoDidLoad(storageType: String)
}

final class MainViewController: UIViewController {
    
    var interactor: MainInteractorInput?
    
    // MARK: Outlets
    
    private lazy var navbar: UINavigationBar = {
        let navbar = UINavigationBar()
        
        let navItem = UINavigationItem()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Обновить",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(update))
        navbar.items = [navItem]
        navbar.barTintColor = .systemGray5
        navbar.translatesAutoresizingMaskIntoConstraints = false
        
        return navbar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.contentInset.top = 5
        tableView.contentInset.bottom = 5
        
        return tableView
    }()
    
    // MARK: Life cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        print(#fileID, #function)
        
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        
        presenter.view = self
        interactor.presenter = presenter
        
        
        self.interactor = interactor
    }
    
    override func viewDidLoad() {
        print(#fileID, #function)
        
        super.viewDidLoad()
        
        setupUI()
        registerCells()
        
        showAction()
        self.interactor?.loadPhotos()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemGray5
        
        self.view.addSubview(navbar)
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navbar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func registerCells() {
        tableView.register(PhotoWithTextCell.self, forCellReuseIdentifier: PhotoWithTextCell.reuseIdentifier)
    }
    
    // MARK: Action
    
    @objc private func update() {
        print(#fileID, #function, "tapped")
        
        showAction()
        interactor?.fetchPhotos()
    }
    
    private func showAction() {
        print(#fileID, #function)
        
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    private func endAction() {
        print(#fileID, #function)
        
        MBProgressHUD.hide(for: view, animated: true)
    }
}

// MARK: MainViewControllerInput

extension MainViewController: MainViewControllerInput {
    
    func photoDidLoad(storageType: String) {
        print(#fileID, #function)
        
        tableView.reloadData()
        navbar.topItem?.title = storageType
        endAction()
    }
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = interactor?.photos.count else {
            return 0
        }
        
        return photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoWithTextCell.reuseIdentifier, for: indexPath) as? PhotoWithTextCell else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        var description = "no description"
        let descriptionTrimed = (interactor?.photos[indexPath.row].photoDescription ?? "").trimmed()
        if !descriptionTrimed.isEmpty {
            description = descriptionTrimed
        }

        var photoURL = ""
        if let photoURLInteractor = interactor?.photos[indexPath.row].photoURL {
            photoURL = photoURLInteractor
        }
        
        let photo = Photo(photoURL: photoURL,
                          description: description)
        
        cell.build(photo: photo)
        return cell
    }
}
