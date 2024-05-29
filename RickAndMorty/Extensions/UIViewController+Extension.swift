//
//  UIViewController+Extension.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 30.05.24.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, actionTitle: String = "OK", actionStyle: UIAlertAction.Style = .default, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: actionStyle) { _ in
                completion?()
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

