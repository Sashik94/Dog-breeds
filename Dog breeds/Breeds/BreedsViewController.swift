//
//  FirstViewController.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class BreedsViewController: UIViewController {
    
    @IBOutlet weak var breedsTableView: UITableView!
    @IBOutlet weak var mainActivityIndicatorView: UIActivityIndicatorView!
    
    var routing = Routing()
    
    var breeds: [String: [String]]!
    var breedsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        routing.delegateBreed = self
        mainActivityIndicatorView.isHidden = false
        mainActivityIndicatorView.startAnimating()
        
        routing.getBreed(type: .breed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let UITableViewCell = sender as! UITableViewCell
        let indexPath = breedsTableView.indexPath(for: UITableViewCell)!
        if let subbreeds = breeds[breedsArray[indexPath.row]], subbreeds.count > 0 {
            if segue.identifier == "ShowSubbreeds" {
                let SVC = segue.destination as! SubbreedsViewController
                SVC.breedStr = breedsArray[indexPath.row]
                SVC.subbbredsArray = subbreeds
            }
        }
        if segue.identifier == "ShowImage" {
            let IVC = segue.destination as! ImageViewController
            IVC.breedString = breedsArray[indexPath.row]
        }
    }
}

extension BreedsViewController: PresentBreedProtocol {
    func presentBreed(response: FetchType<Breed>) {
        switch response {
        case .success(let track):
            breeds = track.message
            guard let breeds = breeds else { return }
            let array = breeds.keys.sorted()
            for type in array {
                breedsArray.append(type)
            }
            DispatchQueue.main.async {
                self.breedsTableView.reloadData()
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
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
          exit(0)
        })
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.routing.getBreed(type: .breed)
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
}

extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let track = breedsArray[indexPath.row]
        
        var reuseIdentifier = "BreedsToSubCell"
        
        if let countSubbreeds = breeds[track]?.count, countSubbreeds == 0 {
            reuseIdentifier = "BreedsToImageCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BreedsTableViewCell
        
        cell.nameLabel.text = track
        if let countSubbreeds = breeds[track]?.count, countSubbreeds > 0 {
            cell.countSubbreedsLabel.text = "(\(countSubbreeds) subbreeds)"
        } else {
            cell.countSubbreedsLabel.text = ""
        }
        
        return cell
    }
    
}
