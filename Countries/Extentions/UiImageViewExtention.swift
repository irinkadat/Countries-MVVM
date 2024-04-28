//
//  UiImageViewExtention.swift
//  Countries
//
//  Created by Irinka Datoshvili on 28.04.24.
//

import UIKit

extension UIImageView {
    func fetchImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self]  data ,_,_ in
            guard let data = data, let image = UIImage(data: data)
            else {return}
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
