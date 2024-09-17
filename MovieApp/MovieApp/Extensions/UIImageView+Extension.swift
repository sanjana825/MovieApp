//
//  UIImageView+Extension.swift
//  MovieApp
//
//  Created by Sanjana on 17/09/24.
//

import Foundation
import UIKit

// MARK: - UIImageView method
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill){
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
            
        }.resume()
    }
}

