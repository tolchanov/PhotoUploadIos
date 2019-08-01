//
//  URLsConfigurator.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation

class URLsConfigurator {
    static func configure(view: URLsViewController) {
        let router = URLsRouterImplementation(view: view)
        let presenter = URLsPresenterImplementation(view: view, router: router)
        
        view.presenter = presenter
    }
}
