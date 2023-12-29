//
//  BilgiCollectionViewCell.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 12.11.2023.
//

import UIKit

class BilgiCollectionViewCell: UICollectionViewCell {
    
    var actionButonDidTap: (()->Void)?
    
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var bilgiLabel: UILabel!
    @IBOutlet weak var ilerleButon: UIButton!
        
    @IBAction func ilerleButonTiklandi(_ sender: Any) {
        actionButonDidTap?()
    }
    
    func configure(with animasyon: Animasyon){
        bilgiLabel.text = animasyon.title
        ilerleButon.backgroundColor = animasyon.butonRenk
        ilerleButon.setTitle(animasyon.butonTitle, for: .normal)
        
    }
    
    
}
