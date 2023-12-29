//
//  ViewController.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 9.11.2023.
//

import UIKit

struct Animasyon{
    let title : String
    let animasyonTitle : String
    let butonRenk : UIColor
    let butonTitle : String
    
    static let collection : [Animasyon] = [
        .init(title: "En güncel haberler", animasyonTitle: "", butonRenk: .systemBlue, butonTitle: "İlerle"),
        .init(title: "Haberleri Favorile", animasyonTitle: "", butonRenk: .systemRed, butonTitle: "Başlayalım")
    ]
}

class BilgiEkrani: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var animasyon: [Animasyon] = Animasyon.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        
    }
    
    func setupPageControl(){
        pageControl.numberOfPages = animasyon.count
        
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
    }
    
    func handleActionButonTap(at indexPath: IndexPath){
        if indexPath.item == animasyon.count-1{
            girisYonlendir()
        }else{
            let ilerleItem = indexPath.item+1
            let ilerleIndexPath = IndexPath(item: ilerleItem, section:0)
            collectionView.scrollToItem(at: ilerleIndexPath, at: .top, animated: true)
            pageControl.currentPage = ilerleItem
        }
    }
    
    func girisYonlendir(){
        let girisVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GirisVC")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window{
            
            window.rootViewController = girisVC
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve ,animations: nil, completion: nil)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(collectionView.contentOffset.y / scrollView.frame.size.height)
        pageControl.currentPage = index
    }
}

extension BilgiEkrani: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animasyon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! BilgiCollectionViewCell
        
        let animasyon = animasyon[indexPath.item]
        cell.configure(with: animasyon)
        
        cell.actionButonDidTap = { [weak self] in
            self?.handleActionButonTap(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
