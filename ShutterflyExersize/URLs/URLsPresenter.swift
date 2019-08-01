//
//  URLsPresenter.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIApplication

protocol URLsView: class {
    func reloadData()
}

protocol URLsPresenter {
    var numberOfURLs: Int { get }
    
    func viewWillAppear()
    func configure(_ cell: URLCell, for index: Int)
    func urlSelected(with index: Int)
}

protocol URLsRouter {
    
}

class URLsPresenterImplementation {
    private weak var view: URLsView?
    private let router: URLsRouter
    
    var urls = [URL]()
    
    //MARK: -
    
    init(view: URLsView, router: URLsRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: -
    
    private func loadSaveData()  {
        let context: NSManagedObjectContext = CoreDataHelper.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        do{
            let urlsResult = try context.fetch(request)
            urlsResult.forEach({ [weak self] in
                if let urlStr = $0.url, let url = URL(string: urlStr) {
                    self?.urls.append(url)
                }
            })
            view?.reloadData()
        } catch {
            print("Could not load save data: \(error.localizedDescription)")
        }
    }
}

//MARK: - URLsPresenter
extension URLsPresenterImplementation: URLsPresenter {
    var numberOfURLs: Int {
        return urls.count
    }
    
    func viewWillAppear() {
        loadSaveData()
    }
    
    func configure(_ cell: URLCell, for index: Int) {
        guard urls.count > index else { return }
        let url = urls[index]
        cell.textLabel?.text = url.absoluteString
    }
    
    func urlSelected(with index: Int) {
        guard urls.count > index else { return }
        let url = urls[index]
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}







