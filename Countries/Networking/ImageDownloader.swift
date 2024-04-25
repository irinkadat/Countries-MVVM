//
//  ImageDownloader.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }.resume()
    }
}

