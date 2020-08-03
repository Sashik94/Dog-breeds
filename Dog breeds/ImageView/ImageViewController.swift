//
//  ImageViewController.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageNavigationItem: UINavigationItem!
    @IBOutlet weak var mainActivityIndicatorView: UIActivityIndicatorView!
    
    var routing = Routing()
    var breedString: String?
    var subbreedString: String?
    var breedRequestStr = ""
    var arrayImagesURL: [String] = []
    
    var arrayImagesURLRealm: [BreedImageRealm]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        routing.delegateImage = self
        mainActivityIndicatorView.isHidden = false
        mainActivityIndicatorView.startAnimating()
        imageNavigationItem.title = breedRequestStr
        
        if let breedString = breedString, let subbreedString = subbreedString {
            breedRequestStr = "\(breedString)/\(subbreedString)"
            imageNavigationItem.title = "\(breedString) \(subbreedString)"
        } else if let breedString = breedString {
            breedRequestStr = breedString
            imageNavigationItem.title = breedString
        }
        if let arrayImagesURLRealm = arrayImagesURLRealm {
            arrayImagesURL.removeAll()
            for url in arrayImagesURLRealm {
                if !url.isInvalidated {
                    arrayImagesURL.append(url.imageURL)
                }
            }
        } else {
            routing.getImage(type: .imageBreed(breedRequestStr))
        }
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        
        let myActionSheet = UIAlertController(title: "Share photo", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: UIAlertAction.Style.default) { (action) in
            print("Share action button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            print("Cancel action button tapped")
        }
        
        myActionSheet.addAction(shareAction)
        myActionSheet.addAction(cancelAction)
        
        present(myActionSheet, animated: true, completion: nil)
    }
    
}

extension ImageViewController: PresentImageProtocol {
    
    func presentImage(response: FetchType<Image>) {
        switch response {
        case .success(let track):
            arrayImagesURL = track.message
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
                self.mainActivityIndicatorView.stopAnimating()
            }
        case .failure(let error):
            print(error)
            DispatchQueue.main.async {
                self.errorAlert(with: error)
            }
        }
    }
    
    func errorAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: "Повторите попытку.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: { [weak self] (_ action: UIAlertAction) -> Void in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        })
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.routing.getImage(type: .imageBreed(self.breedRequestStr))
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        let track = self.arrayImagesURL[indexPath.row]
        
        cell.breed = breedString
        cell.subbreed = subbreedString
        cell.imageURL = track
        
        return cell
    }
    
    // MARK: - CollectionViewFlowLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width
        let h = collectionView.bounds.height
        return CGSize(width: w, height: h)
    }
}
