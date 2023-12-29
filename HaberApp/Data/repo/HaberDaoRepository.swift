//
//  HaberDaoRepository.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 9.11.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import RxSwift

class HaberDaoRepository{
    
    var disposeBag = DisposeBag()
    var newsList = BehaviorSubject<[Articles]>(value: [])
    let apiService = APIService()
    var hata = PublishSubject<String?>()
 
    func girisYap(email: String, sifre: String, completion: @escaping (Result<User?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: sifre) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user))
            }
        }
    }
    
    func kayitOl(email: String, sifre: String, completion: @escaping (Result<User?, Error>) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: sifre){ (result,error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.user))
            }
        }
    }
    
    func haberleriGetir(query: String?) {
            apiService.haberleriAl(query: query)
                .subscribe(
                    onNext: { [weak self] newsList in
                        print("Başarılı: \(newsList)")
                        self?.newsList.onNext(newsList)
                    },
                    onError: { [weak self] error in
                        if let decodingError = error as? DecodingError {
                            print("JSON Decode Hatası: \(decodingError)")
                        } else {
                            print("Diğer Hata: \(error.localizedDescription)")
                        }
                        self?.hata.onNext("Hata oluştu!!!: \(error.localizedDescription)")
                    }
                )
                .disposed(by: disposeBag)
        }
    
    func search(query: String?){
        apiService.haberleriAl(query: query)
            .subscribe(
                onNext:  { [weak self] newsList in
                    self?.newsList.onNext(newsList)

                }, onError: {[weak self] error in
                    self?.hata.onNext("Hata oluştu!!!: \(error.localizedDescription)")
             }
        ) .disposed(by: disposeBag)
    }
    

}

