//
//  HaberEkrani.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 21.11.2023.
//

import UIKit
import RxSwift
import SideMenu
import CoreData
import FirebaseAuth

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let newsFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favori", into: context)

protocol MenuListControllerDelegate: AnyObject{
    func didSelectSideMenu(item:String)
}


class HaberEkrani: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectCategory:String?
    var sideMenu:SideMenuNavigationController?
    
    var viewModel = HaberEkraniViewModel()
    var disposeBag = DisposeBag()
    var newsList = [Articles]()
    let userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCategory = "general"
        fetchSelectCategory()
        
        sideMenu = SideMenuNavigationController(rootViewController: MenuListController())
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        if let menuListController = sideMenu?.viewControllers.first as? MenuListController {
                    menuListController.delegate = self
                }
        
        print("ViewDidload")
        if searchBar == nil {
            print("searchBar is nil!")
        } else {
            searchBar.delegate = self
        }

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        viewModel.haberleriGetir(query: "")
        
        viewModel.newsList.subscribe(onNext: { liste in
            self.newsList = liste
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, onError: { error in
            print("ViewModel Hata: \(error.localizedDescription)")
        })
        .disposed(by: viewModel.disposeBag)
        

    }
    deinit {
        print("HaberEkrani deinit")
    }
    
    @IBAction func menuTiklandi(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "haberDetay"{
            if let haber = sender as? Articles, let gidilecekVC = segue.destination as? HaberDetay, let haberUrl = URL(string: haber.url!){
                gidilecekVC.haberUrl = haberUrl
            }
        }
    }
    
}

extension HaberEkrani: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let haber = newsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "haberCell") as! HaberCell
        cell.setting(with: haber)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let haber = newsList[indexPath.row]
        performSegue(withIdentifier: "haberDetay", sender: haber)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favAction = UIContextualAction(style: .destructive, title: "Favori") { contextualAction, view, bool in
            HaberApp.Util.showAlert(in: self, title: "Başarılı", message: "Favorilere Eklendi.")
            
        }
        return UISwipeActionsConfiguration(actions: [favAction])
    }
    
}

/* let news = self.newsList[indexPath.row]
 
 DispatchQueue.global().async {
     newsFavorite.setValue(UUID(), forKey: "id")
     newsFavorite.setValue(self.userId, forKey: "user_id")
     newsFavorite.setValue(news.url, forKey: "url")
     
     do{
         try context.save()
         HaberApp.Util.showAlert(in: self, title: "Başarılı", message: "Favorilere Eklendi.")
     }catch{
         print("Favorilere ekleme erroru!!!!")
     }
 } */

extension HaberEkrani: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchKey: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.search(searchKey: nil)
        searchBar.resignFirstResponder()
    }
}

class MenuListController: UITableViewController{
    var item = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    var delegate:MenuListControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = item[indexPath.row]
        delegate?.didSelectSideMenu(item: selectedItem)
        print("Did Select Side Menu: \(selectedItem)")
    }
    
}

extension HaberEkrani: MenuListControllerDelegate{    
    
    func didSelectSideMenu(item: String) {
        
        selectCategory = item
        fetchSelectCategory()
        print("Seçilen Kategori: \(item)")
        sideMenu?.dismiss(animated: true, completion: nil)
        
    }
    
    func fetchSelectCategory(){
        guard let selectCategory=selectCategory else{
            print("Seçilen Kategori yok.")
            return
        }
        
        let apiKey = "25bf0e2d4e41488c940d6c6b0fc8f835"
        let baseUrl = "https://newsapi.org/v2/top-headlines"
        let country =  "us"
        
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "category", value: selectCategory),
            URLQueryItem(name: "apiKey", value: apiKey)]
        
        guard let url = components?.url else{
            print("URL oluşturulamadı.")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ (data,response,error) in
            if let error = error{
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else{
                print("Veri alınamadı.")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                self.newsList = response.articles ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print("JSON dönüşüm hatası: \(error.localizedDescription)")
            }
            
        }
        dataTask.resume()
    }
}

