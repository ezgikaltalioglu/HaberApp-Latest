//
//  GirisEkrani.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 9.11.2023.
//

import UIKit


class GirisEkrani: UIViewController {
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var sifreTf: UITextField!
   
    var viewModel = GirisEkraniViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func girisYapButon(_ sender: Any) {
        
        guard let email = emailTf.text, !email.isEmpty,
                  let sifre = sifreTf.text, !sifre.isEmpty else {
            HaberApp.Util.showAlert(in: self, title: "Hata", message: "E-posta ve şifre boş bırakılamaz.")
                      return
            }
        
        viewModel.girisYap(email: email, sifre: sifre){ result in
            switch result{
            case .success(_):
                print("Giriş Başarılı!")
                self.performSegue(withIdentifier: "haberEkrani", sender: self)
    
            case .failure(let error):
                print("Giriş Hatası: \(error.localizedDescription)")
                HaberApp.Util.showAlert(in: self, title: "Hata", message: "E-posta veya şifre yanlış.")
            }
            
        }
        
    }
    
  
    

}
