//
//  IconDetailViewController.swift
//  CollectionView Demo
//
//  Created by Sorfian on 08/04/23.
//

import UIKit

class IconDetailViewController: UIViewController {
    
    var icon: Icon?
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.text = icon?.name
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = icon?.description
            descriptionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.image = UIImage(named: icon?.imageName ?? "")
        }
    }
    
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            if let icon = icon {
                priceLabel.text = "$\(icon.price)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
