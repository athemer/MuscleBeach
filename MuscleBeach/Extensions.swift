//
//  Extensions.swift
//  NewMessenger
//
//  Created by Farukh IQBAL on 25/02/2017.
//  Copyright © 2017 Farukh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(urlString: String) {

        self.image = nil

        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage as? UIImage
            return
        }

        let url = NSURL(string: urlString)
        // swiftlint:disable:next force_cast
        URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, _, error) in
        // swiftlint:disable:previous force_cast

            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {

                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
