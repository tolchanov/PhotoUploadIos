//
//  URLsViewController.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import UIKit

class URLsViewController: UIViewController {
    var presenter: URLsPresenter?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tblURLs: UITableView!
    
    //MARK: - Static
    
    static func instantiate() -> URLsViewController? {
        return UIStoryboard(name: "URLs", bundle: nil).instantiateViewController(withIdentifier: "URLsViewController") as? URLsViewController
    }

    //MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        URLsConfigurator.configure(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
}

//MARK: - URLsView
extension URLsViewController: URLsView {
    func reloadData() {
        tblURLs.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension URLsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfURLs ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: URLCell.identifier, for: indexPath) as! URLCell
        presenter?.configure(cell, for: indexPath.row)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension URLsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.urlSelected(with: indexPath.row)
    }
}
