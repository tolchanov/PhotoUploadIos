//
//  APIHelper.swift
//  ShutterflyExersize
//
//  Created by Red Pill on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation
import UIKit

class UploadOperation: AsyncOperation {
    let image: UIImage
    var resultUrl: String?
    var resultError: String?
    
    init(image: UIImage) {
        self.image = image
    }
    
    override func main() {
        sendImage(image: image) { (urlStr, errorStr) in
            self.resultUrl = urlStr
            self.resultError = errorStr
            
            self.state = .finished
        }
    }
}







fileprivate func sendImage(image: UIImage, completion: @escaping (String?, String?) -> ()){
    guard let data = UIImageJPEGRepresentation(image, 1) else {
        completion(nil, "Unknown error")
        return
    }
    
    var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
    request.httpMethod = "POST"
    
    let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    
    //Body
    let fullData = photoDataToFormData(data: data, boundary: boundary, fileName: UUID().uuidString)
    request.httpBody = fullData
    request.httpShouldHandleCookies = false
    
    //Headers
    request.setValue("multipart/form-data; boundary=" + boundary,
                     forHTTPHeaderField: "Content-Type")
    request.setValue("Client-ID \(IMGUR_CLIENT)", forHTTPHeaderField: "Authorization")
    request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let data = data else {
            completion(nil, "Unknown error")
            return
        }
        
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//            print("JSON:", json)
//        } catch {
//
//        }
        
        do {
            let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
            completion(uploadResponse.data.link, nil)
        } catch {
            do {
                let errorResponse = try JSONDecoder().decode(UploadErrorResponse.self, from: data)
                completion(nil, errorResponse.data.error.message)
            } catch {
                print(error)
                completion(nil, "Unknown error")
            }
        }
        }.resume()
}

fileprivate func photoDataToFormData(data: Data, boundary: String, fileName: String) -> Data {
    var fullData = Data()
    
    // 1 - Boundary should start with --
    let lineOne = "--" + boundary + "\r\n"
    fullData.append(lineOne.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    // 2
    let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
    fullData.append(lineTwo.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    // 3
    let lineThree = "Content-Type: image/jpg\r\n\r\n"
    fullData.append(lineThree.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    // 4
    fullData.append(data)
    // 5
    let lineFive = "\r\n"
    fullData.append(lineFive.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    // 6 - The end. Notice -- at the start and at the end
    let lineSix = "--" + boundary + "--\r\n"
    fullData.append(lineSix.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
    
    return fullData
}
