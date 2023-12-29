//
//  HaberEkraniViewModel.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 21.11.2023.
//

import Foundation
import RxSwift

class HaberEkraniViewModel{
    
    var hrepo = HaberDaoRepository()
    var newsList = BehaviorSubject<[Articles]>(value: [])
    var disposeBag = DisposeBag()
    
    init(){
        hrepo.newsList
                .subscribe(onNext: { [weak self] haberListesi in
                    self?.newsList.onNext(haberListesi)
                })
                .disposed(by: disposeBag)
        
    }
    
    func haberleriGetir(query: String){
        hrepo.haberleriGetir(query: query)
    }
    
    func search(searchKey:String?){
        hrepo.search(query: searchKey)
    }

}

