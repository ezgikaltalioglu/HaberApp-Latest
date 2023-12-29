//
//  APIService.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 25.11.2023.
//

import Foundation
import RxSwift

class APIService{
    
    let disposeBag = DisposeBag()
    
    func haberleriAl(query: String?) -> Observable<[Articles]>{
        let apiKey = "25bf0e2d4e41488c940d6c6b0fc8f835"
        var url = "https://newsapi.org/v2/everything?q=Apple&from=2023-11-24&sortBy=popularity&apiKey=\(apiKey)"
        
        if let query = query, !query.isEmpty{
            url = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
        }
        
        guard let url = URL(string: url) else {
            return Observable.error(NSError(domain: "Geçersiz URL", code: 0, userInfo: nil))
        }
        
        return Observable.create{ observer in
            let task = URLSession.shared.dataTask(with: url){ data, _, error in
                
                if let error = error{
                    observer.onError(error)
                    return
                }
                
                if let data = data {
                    print("Gelen Veri: \(String(data: data, encoding: .utf8) ?? "Data çözülemedi.")")
                        do {
                              let haber = try JSONDecoder().decode(Response.self, from: data)
                              observer.onNext(haber.articles ?? [])
                              observer.onCompleted()
                            } catch {
                                observer.onError(error)
                            }
                    } else {
                          print("Hata: Data boş.")
                          observer.onError(NSError(domain: "Empty Data", code: 1, userInfo: nil))
                     }
                
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
 
}
