//
//  FavoriCell.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 28.12.2023.
//

import UIKit

class FavoriCell: UITableViewCell {

    @IBOutlet weak var favoriLabel: UILabel!
    @IBOutlet weak var favoriImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func favoriSetting(with news: Articles){
        
        if let imageURLString = news.urlToImage, let imageURl = URL(string: imageURLString){
            URLSession.shared.dataTask(with: imageURl){data ,_,error in
               if let error = error{
                    print("Resim Yüklenemedi! \(error.localizedDescription)")
                    return
                }
                    
               if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                    self.favoriImage.image = image
                    self.favoriLabel.text = news.title
                    }
                }
                    
            } .resume()
          } else{
              print("Haber resmi yok veya geçerli bir URL oluşturulamadı.")
          }
   }

}
