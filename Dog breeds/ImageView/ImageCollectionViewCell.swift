//
//  ImageCollectionViewCell.swift
//  Dog breeds
//
//  Created by Александр Осипов on 02.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var breed: String?
    var subbreed: String?
    var imageURL: String? { didSet { configureCell(imageURL!) } }
    
    @IBAction func favoriteButtonTap(_ sender: UIButton) {
        if sender.tintColor == UIColor.black {
            if let breed = breed, let imageURL = imageURL {
                Persistance.shared.writeModel(breedStr: breed, subbreedStr: subbreed, imageURLStr: imageURL)
            }
            sender.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.1329793036, alpha: 1)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            Persistance.shared.deleteModel(imageURL: imageURL!)
            sender.tintColor = UIColor.black
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func writeModel() {
        if let breed = breed, let imageURL = imageURL {
            Persistance.shared.writeModel(breedStr: breed, subbreedStr: subbreed, imageURLStr: imageURL)
        }
    }
    
    private func configureCell(_ imageURL: String) {
        activityIndicator.startAnimating()
        mainImageView.image = nil
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: imageURL) else { return }
            do {
                let image = UIImage(data: try Data(contentsOf: url))
                DispatchQueue.main.async {
                    if Persistance.shared.readImage(imageURL: imageURL) {
                        self.favoriteButton.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.1329793036, alpha: 1)
                        self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    } else {
                        self.favoriteButton.tintColor = UIColor.black
                        self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                    self.mainImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            } catch { }
        }
    }
    
}
