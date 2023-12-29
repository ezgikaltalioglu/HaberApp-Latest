//
//  GirisEkraniViewModel.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 11.11.2023.
//

import Foundation
import FirebaseAuth


class GirisEkraniViewModel{
  
    var hrepo = HaberDaoRepository()
    
    init(hrepo: HaberDaoRepository = HaberDaoRepository()) {
        self.hrepo = hrepo
    }
    
    func girisYap(email: String, sifre: String, completion: @escaping (Result<User?, Error>) -> Void){
        hrepo.girisYap(email: email, sifre: sifre, completion: completion)
    }
    
}

