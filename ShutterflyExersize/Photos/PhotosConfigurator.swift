//
//  PhotosConfigurator.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation

class PhotosConfigurator {
    static func configure(view: PhotosViewController) {
        let router = PhotosRouterImplementation(view: view)
        let presenter = PhotosPresenterImplementation(view: view, router: router)
        
        view.presenter = presenter
    }
}
