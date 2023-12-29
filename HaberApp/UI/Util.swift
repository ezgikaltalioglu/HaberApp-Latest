//
//  UtilView.swift
//  HaberApp
//
//  Created by Ezgi Kaltalıoğlu on 19.11.2023.
//

import UIKit

class Util {
    static func showAlert(in viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        }

        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}


