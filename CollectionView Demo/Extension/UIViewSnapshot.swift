//
//  UIViewSnapshot.swift
//  CollectionView Demo
//
//  Created by Sorfian on 08/04/23.
//

import UIKit

extension UIView {
    var snapshot: UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        return image
    }
}
