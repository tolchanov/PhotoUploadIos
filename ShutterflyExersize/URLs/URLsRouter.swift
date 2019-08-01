//
//  URLsRouter.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation

class URLsRouterImplementation {
    private weak var view: URLsViewController?
    
    init(view: URLsViewController) {
        self.view = view
    }
}

//MARK: - URLsRouter
extension URLsRouterImplementation: URLsRouter {
    
}
