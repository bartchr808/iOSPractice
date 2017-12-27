//
//  Photo.swift
//  LearningCamera
//
//  Created by Bart Chrzaszcz on 2017-12-23.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

struct Photo {
    let image: UIImage
    let label: String
    
    init(image: UIImage, label: String) {
        self.image = image
        self.label = label
    }
    
    init?(filePath: NSURL) {
        if let image = UIImage(contentsOfFile: filePath.relativePath!) {
            let label = filePath.deletingPathExtension?.lastPathComponent ?? ""
            self.init(image: image, label: label)
        } else {
            return nil
        }
    }
    
    enum myError: String, Error {
        case CouldntGetImageData = "Couldn't get data from image"
        case CouldntWriteImageData = "Couldn't write image data"
    }
    
    func saveToDirectory(directory: NSURL) throws {
        let timeStamp = "\(NSDate().timeIntervalSince1970)"
        let fullDirectory = directory.appendingPathComponent(timeStamp)
        try FileManager.default.createDirectory(
            at: fullDirectory!,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let fileName = "\(self.label).jpg"
        let filePath = fullDirectory?.appendingPathComponent(fileName)
        if let data = UIImageJPEGRepresentation(self.image, 1) {
            do {
                try data.write(to: filePath!)
            } catch {
                throw myError.CouldntWriteImageData
            }
        } else {
            throw myError.CouldntGetImageData
        }
    }
}
