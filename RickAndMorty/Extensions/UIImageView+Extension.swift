//
//  UIImageView+Extension.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, NSData>()
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        if let cachedData = UIImageView.imageCache.object(forKey: urlString as NSString) {
            self.image = UIImage(data: cachedData as Data)
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    UIImageView.imageCache.setObject(data as NSData, forKey: urlString as NSString)
                    self.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
    
    static func clearImageCache() {
        imageCache.removeAllObjects()
    }
}
