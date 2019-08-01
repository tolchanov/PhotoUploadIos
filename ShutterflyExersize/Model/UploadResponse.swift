//
//  UploadResponse.swift
//  ShutterflyExersize
//
//  Created by Red Pill on 22.08.2018.
//  Copyright © 2018 ideveloper. All rights reserved.
//

import Foundation

struct UploadResponse: Codable {
    struct Data: Codable {
        let link: String
    }
    let success: Bool
    let data: UploadResponse.Data
}

struct UploadErrorResponse: Codable {
    struct Data: Codable {
        struct Error: Codable {
            let message: String
        }
        let error: UploadErrorResponse.Data.Error
    }
    
    let success: Bool
    let data: UploadErrorResponse.Data
}
