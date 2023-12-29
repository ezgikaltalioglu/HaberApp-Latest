//
//  KayitEkrani.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 9.11.2023.
//

import UIKit

class KayitEkrani: UIViewController {
    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var sifreTf: UITextField!
    
    let viewmodel = KayitEkraniViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func kayitButon(_ sender: Any) {
        
        guard let email = emailTf.text, !email.isEmpty,
                  let sifre = sifreTf.text, !sifre.isEmpty else {
            Util.showAlert(in: self, title: "Hata", message: "E-posta ve şifre boş bırakılamaz.")
                      return
            }
        
        viewmodel.kayitOl(email: email, sifre: sifre){result in
            switch result{
            case .success(_):
                Util.showAlert(in: self, title: "Kayıt Başarılı", message: "Kayıt Başarılı. Giriş Yapabilirsiniz!"){
                    self.performSegue(withIdentifier: "girisEkrani", sender: self)
                }

                                
            case .failure(let error):
                print("Giriş Hatası: \(error.localizedDescription)")
            }
        }
    }
    
 

    

}
