//
//  Response.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 23.11.2023.
//

import Foundation

struct Response: Codable{
    
    let status : String?
    let totalResults :Int?
    let articles : [Articles]?
    
}

struct Articles: Codable{
    let source : Source?
    let author : String?
    let title :String?
    let description : String?
    let url :String?
    let urlToImage : String?
    let publishedAt :String?
    let content : String?
    
    /*var category: String? {
            return source?.name
        }*/
}


struct Source: Codable{
    let id : String?
    let name :String?
}
