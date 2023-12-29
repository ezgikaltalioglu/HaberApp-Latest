//
//  TableViewCell.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 21.11.2023.
//

import UIKit

class HaberCell: UITableViewCell {
    
    
    @IBOutlet weak var haberImage: UIImageView!
    @IBOutlet weak var haberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setting(with news: Articles){
        
        if let imageURLString = news.urlToImage, let imageURl = URL(string: imageURLString){
            URLSession.shared.dataTask(with: imageURl){data ,_,error in
                    
              
                
               if let error = error{
                    print("Resim Yüklenemedi! \(error.localizedDescription)")
                    return
                }
                    
               if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                    self.haberImage.image = image
                    self.haberLabel.text = news.title
                    }
                }
                    
            } .resume()
                
                
          } else{
              print("Haber resmi yok veya geçerli bir URL oluşturulamadı.")
          }
   }

}
