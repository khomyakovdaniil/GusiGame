//
//  UIViewExtensionAsImage.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 24.12.2021.
//

import Foundation
import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    func copyView() -> UIView {
            return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! UIView
        }
}
