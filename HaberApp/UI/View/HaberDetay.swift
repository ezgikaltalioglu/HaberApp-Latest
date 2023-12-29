//
//  HaberDetay.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 27.12.2023.
//

import UIKit
import WebKit

class HaberDetay: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    var haberUrl:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = haberUrl{
            let request = URLRequest(url: url)
            webView.load(request)
        }
    
    }
    


}
