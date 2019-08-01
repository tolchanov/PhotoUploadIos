//
//  PhotosViewController.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    var presenter: PhotosPresenter?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var clvPhotos: UICollectionView!
    
    //MARK: - Static
    
    static func instantiate() -> PhotosViewController? {
        return UIStoryboard(name: "Photos", bundle: nil).instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController
    }

    //MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotosConfigurator.configure(view: self)
        presenter?.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = clvPhotos.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        flowLayout.invalidateLayout()
    }

    //MARK: - Actions
    
    @IBAction private func btnLinksPressed(_ sender: UIBarButtonItem) {
        presenter?.linksAction()
    }
}

//MARK: - PhotosView
extension PhotosViewController: PhotosView {
    
    func reloadData() {
        clvPhotos.reloadData()
    }
    
    func reloadCell(with index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        clvPhotos.reloadItems(at: [indexPath])
    }
    
    func showAlert(with message: String, okExist: Bool) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        if okExist {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfPhotos ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        presenter?.configure(cell, for: indexPath.row)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.photoSelected(with: indexPath.item)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let spaceWithoutInsets = collectionView.bounds.width -
        collectionView.contentInset.left - collectionView.contentInset.right -
        flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        var numberOfPhotos: CGFloat = 3
        
        //Is Landscape
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            numberOfPhotos = 5
        }
        let width = (spaceWithoutInsets - flowLayout.minimumInteritemSpacing * (numberOfPhotos - 1)) / numberOfPhotos
        
        return CGSize(width: width, height: width)
    }
}







