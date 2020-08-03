//
//  SubBreedsTableViewController.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class SubbreedsViewController: UIViewController {

    @IBOutlet weak var subbreedsTableView: UITableView!
    @IBOutlet weak var subbreedNavigationItem: UINavigationItem!
    
    var breedStr: String = ""
    var subbbredsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subbreedNavigationItem.title = breedStr
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let UITableViewCell = sender as! UITableViewCell
        let indexPath = subbreedsTableView.indexPath(for: UITableViewCell)!
        if segue.identifier == "ShowImage" {
            let IVC = segue.destination as! ImageViewController
            IVC.breedString = breedStr
            IVC.subbreedString = subbbredsArray[indexPath.row]
        }
    }
}

extension SubbreedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subbbredsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubbreedsCell", for: indexPath) as! SubbreedsTableViewCell
        
        let track = subbbredsArray[indexPath.row]
        
        cell.nameLabel.text = track
        
        return cell
    }
    
}
