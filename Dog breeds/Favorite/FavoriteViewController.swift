//
//  SecondViewController.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTabelView: UITableView!
    
    var breeds: [BreedRealm]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        breeds = Persistance.shared.readModel()
        favoriteTabelView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let UITableViewCell = sender as! UITableViewCell
        let indexPath = favoriteTabelView.indexPath(for: UITableViewCell)!
        if segue.identifier == "ShowImage" {
            let IVC = segue.destination as! ImageViewController
            IVC.breedRequestStr = breeds![indexPath.row].breed
            IVC.arrayImagesURLRealm = breeds?[indexPath.row].image.array
        }
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedsCell", for: indexPath) as! FavoriteTableViewCell
        let track = breeds![indexPath.row]
        
        cell.favoriteNameLabel.text = track.breed
        cell.favoriteCountLabel.text = "\(track.image.count) photo"
        
        return cell
    }
}
