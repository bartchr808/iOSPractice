//
//  ViewController.swift
//  LearningCamera
//
//  Created by Bart Chrzaszcz on 2017-12-22.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var photoStore: PhotoStore!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try self.photoStore.loadPhotos()
            self.collectionView.reloadData()
        } catch let error {
            self.displayError(
                error: error,
                withTitle: "Error Loading Photos"
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.photoStore = PhotoStore(
            cellForPhoto: self.createCellForPhoto
        )
        self.collectionView.dataSource = self.photoStore
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapTakePhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        
        self.present(
            imagePicker,
            animated: true,
            completion: nil
        )
    }
    
    func createCellForPhoto(
        photo: Photo,
        indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: "DefaultCell",
                for: indexPath as IndexPath
            ) as! PhotoCollectionViewCell
        cell.imageView.image = photo.image
        cell.label.text = photo.label
        return cell
    }
}

extension ViewController: UINavigationControllerDelegate {}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) {
            // Ask User for Label
            
            let alertController = UIAlertController(
                title: "Photo Label",
                message: "How would you like to label your photo?",
                preferredStyle: .alert
            )
            /*alertController.addTextField() { textField in
                let saveAction = UIAlertAction(
                    title: "Save",
                    style: .default
                ) { action in
                    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        let label = textField.text ?? ""
                        let indexPath = self.photoStore.saveNewPhotoWithImage(
                            image: pickedImage,
                            labeled: label
                        )
                        self.collectionView.insertItems(at: [indexPath as IndexPath])
                    }
                }
                alertController.addAction(saveAction)
            }*/
            
            alertController.addTextField()
                {
                    textField in
                    let saveAction = self.createSaveActionWithTextField(
                        textField: textField,
                        andImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!
                    )
                    alertController.addAction(saveAction)
            }
            
            self.present(
                alertController,
                animated: true,
                completion: nil
            )
        }
    }
}


// Error Handling
extension ViewController {
    func displayErrorWithTitle(title: String?, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        self.present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    func displayError(error: Error, withTitle: String) {
        switch error {
        case let error as NSError:
            self.displayErrorWithTitle(
                title: title,
                message: error.localizedDescription
            )
        case let error as Photo.myError:
            self.displayErrorWithTitle(
                title: title,
                message: error.rawValue
            )
        default:
            self.displayErrorWithTitle(
                title: title,
                message: "Unknown Error"
            )
        }
    }
}

extension ViewController {
    func createSaveActionWithTextField(
        textField: UITextField,
        andImage image: UIImage
        ) -> UIAlertAction
    {
        return UIAlertAction(
            title: "Save",
            style: .default
        ) { action in
            do {
                let indexPath = try self.photoStore
                    .saveNewPhotoWithImage(
                        image: image,
                        labeled: textField.text ?? ""
                )
                self.collectionView.insertItems(
                    at: [indexPath as IndexPath]
                ) }
            catch let error {
                self.displayError(
                    error: error,
                    withTitle: "Error Saving Photo"
                )
            }
        }
    }
}
