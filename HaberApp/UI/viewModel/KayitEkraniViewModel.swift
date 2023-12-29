//
//  KayitEkraniViewModel.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 11.11.2023.
//

import Foundation
import FirebaseAuth

class KayitEkraniViewModel{
    
    var hrepo = HaberDaoRepository()
    
    init(hrepo: HaberDaoRepository = HaberDaoRepository()) {
        self.hrepo = hrepo
    }
    
    func kayitOl(email: String, sifre: String, completion: @escaping (Result<User?, Error>) -> Void){
        hrepo.kayitOl(email: email, sifre: sifre, completion: completion)
    }
}
