//
//  FavoriEkrani.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 23.11.2023.
//

import UIKit
import CoreData

let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")

class FavoriEkrani: UIViewController {

    @IBOutlet weak var favoriTableView: UITableView!
    var favoriListe:[Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriTableView.delegate = self
        favoriTableView.dataSource = self
        favoriTableView.reloadData()
    }


}

extension FavoriEkrani: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favori = favoriListe[indexPath.row] as! NSManagedObject
        let cell = favoriTableView.dequeueReusableCell(withIdentifier: "favoriCell") as! FavoriCell
 
        return cell
    }
}
