//
//  PhotosRouter.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation

class PhotosRouterImplementation {
    private weak var view: PhotosViewController?
    
    init(view: PhotosViewController) {
        self.view = view
    }
}

//MARK: - PhotosRouter
extension PhotosRouterImplementation: PhotosRouter {
    func toLinks() {
        guard let linksController = URLsViewController.instantiate() else { return }
        view?.navigationController?.show(linksController, sender: self)
    }
}
