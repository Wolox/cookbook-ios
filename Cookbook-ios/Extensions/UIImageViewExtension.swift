//
//  UIImageViewExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/31/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, contentMode: mode)
    }
}
