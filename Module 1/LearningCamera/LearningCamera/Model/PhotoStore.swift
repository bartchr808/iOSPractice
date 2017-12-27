//
//  PhotoStore.swift
//  LearningCamera
//
//  Created by Bart Chrzaszcz on 2017-12-24.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class PhotoStore: NSObject {
    var photos = [Photo]()
    var cellForPhoto: (Photo, NSIndexPath) -> UICollectionViewCell
    
    init(
        cellForPhoto: @escaping (Photo, NSIndexPath) -> UICollectionViewCell
        )
    {
        self.cellForPhoto = cellForPhoto
        
        super.init()
    }
    
    func saveNewPhotoWithImage(
        image: UIImage,
        labeled label: String
        ) throws -> NSIndexPath
    {
        let photo = Photo(image: image, label: label)
        try photo.saveToDirectory(directory: self.getSaveDirectory())
        self.photos.append(photo)
        return NSIndexPath(item: self.photos.count - 1, section: 0)
    }
}

// Protocol methods for dealing with collection view with PhotoStore as the datasource
extension PhotoStore: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return self.photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell
    {
        let photo = self.photos[indexPath.item]
        return self.cellForPhoto(photo, indexPath as NSIndexPath)
    }
}

// Permenantly saving photos methods
private extension PhotoStore {
    func getSaveDirectory() throws -> NSURL {
        let fileManager = FileManager.default
        return try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ) as NSURL
    }
}
extension PhotoStore {
    func loadPhotos() throws {
        self.photos.removeAll(keepingCapacity: true)
        
        // get enumerator that goes over our save directory
        let fileManager = FileManager.default
        let saveDirectory = try self.getSaveDirectory()
        let enumerator = fileManager.enumerator(atPath: saveDirectory.relativePath!)
        
        while let file = enumerator?.nextObject() as? String {
            let fileType = enumerator!.fileAttributes![FileAttributeKey.type] as! String
            if fileType == FileAttributeType.typeRegular.rawValue { // check if it is an actual file
                let fullPath = saveDirectory.appendingPathComponent(file)
                if let photo = Photo(filePath: fullPath! as NSURL) {
                    self.photos.append(photo)
                }
            }
        }
    }
}
