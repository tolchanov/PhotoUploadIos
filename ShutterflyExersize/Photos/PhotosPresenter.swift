//
//  PhotosPresenter.swift
//  ShutterflyExersize
//
//  Created by ideveloper on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

//PHAssetCollectionSubtypeAlbumMyPhotoStream (together with PHAssetCollectionTypeAlbum) - fetches the Photo Stream album.
//PHAssetCollectionSubtypeSmartAlbumUserLibrary (together with PHAssetCollectionTypeSmartAlbum) - fetches the Camera Roll album.

import Foundation
import UIKit.UIImage
import Photos

protocol PhotosView: class {
    func reloadData()
    func reloadCell(with index: Int)
    func showAlert(with message: String, okExist: Bool)
}

protocol PhotosPresenter {
    var numberOfPhotos: Int { get }
    
    func viewDidLoad()
    func configure(_ cell: PhotoCell, for index: Int)
    func photoSelected(with index: Int)
    func linksAction()
}

protocol PhotosRouter {
    func toLinks()
}

class PhotosPresenterImplementation {
    private weak var view: PhotosView?
    private let router: PhotosRouter
    
    var assets = [PHAsset]()
    var uploadingQueue = OperationQueue()
    
    var uploadingIndexes = Set<Int>()
    
    //MARK: -
    
    init(view: PhotosView, router: PhotosRouter) {
        self.view = view
        self.router = router
    }
    
    //MARK: -
    
    private func getCameraRoll() {
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        cameraRoll.enumerateObjects({ [weak self] (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .highQualityFormat
                requestOptions.isSynchronous = true
                
                let fetchResult = PHAsset.fetchAssets(in: obj, options: fetchOptions)
                fetchResult.enumerateObjects { [weak self] asset, index, flag in
                    self?.assets.append(asset)
                }
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
            }
        })
    }
    
    private func sendImage(_ image: UIImage?, with index: Int) {
        guard let image = image else { return }
        uploadingIndexes.insert(index)
        view?.reloadCell(with: index)
        
        let operation = UploadOperation(image: image)
        operation.completionBlock = { [weak self] in
            if let urlStr = operation.resultUrl {
                CoreDataHelper.shared.saveURL(urlStr)
            } else if let error = operation.resultError {
               self?.view?.showAlert(with: error, okExist: true)
            }
            
            self?.uploadingIndexes.remove(index)
            DispatchQueue.main.async {
                self?.view?.reloadCell(with: index)
            }
        }
        
        print("Operation added!")
        uploadingQueue.addOperation(operation)
    }
}

//MARK: - PhotosPresenter
extension PhotosPresenterImplementation: PhotosPresenter {
    var numberOfPhotos: Int {
        return assets.count
    }
    
    func viewDidLoad() {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == .authorized{
                    self?.getCameraRoll()
                } else {
                    self?.view?.showAlert(with: "Photos Access Denied!", okExist: false)
                }
            })
        case .restricted, .denied:
            view?.showAlert(with: "Photos Access Denied!", okExist: false)
        case .authorized:
            getCameraRoll()
        }
    }
    
    func configure(_ cell: PhotoCell, for index: Int) {
        guard assets.count > index else { return }
        let asset = assets[index]
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = false
        
        cell.isLoading = uploadingIndexes.contains(index)
        PHCachingImageManager.default().requestImage(for: asset, targetSize: cell.contentView.bounds.size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
            cell.photo = image
        }
    }
    
    func photoSelected(with index: Int) {
        guard assets.count > index else { return }
        let asset = assets[index]
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = false
        
        //FIXME: target size
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { [weak self] (image, _) in
            self?.sendImage(image, with: index)
        }
    }
    
    func linksAction() {
        router.toLinks()
    }
}










