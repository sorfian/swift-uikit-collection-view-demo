//
//  IconCollectionViewController.swift
//  CollectionView Demo
//
//  Created by Sorfian on 08/04/23.
//

import UIKit

private let reuseIdentifier = "itemcell"

class IconCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private var iconSet: [Icon] = [
        Icon(name: "Candle icon", imageName: "candle", description: "Halloween icons designed by Tania Raskalova.", price: 3.99, isFeatured: false),
        Icon(name: "Cat icon", imageName: "cat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: true),
        Icon(name: "dribbble", imageName: "dribbble", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
        Icon(name: "Ghost icon", imageName: "ghost", description: "Halloween icon designed by Tania Raskalova.", price: 4.99, isFeatured: false),
        Icon(name: "Hat icon", imageName: "hat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
        Icon(name: "Owl icon", imageName: "owl", description: "Halloween icon designed by Tania Raskalova.", price: 5.99, isFeatured: true),
        Icon(name: "Pot icon", imageName: "pot", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
        Icon(name: "Pumkin icon", imageName: "pumkin", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
        Icon(name: "RIP icon", imageName: "rip", description: "Halloween icon designed by Tania Raskalova.", price: 7.99, isFeatured: false),
        Icon(name: "Skull icon", imageName: "skull", description: "Halloween icon designed by Tania Raskalova.", price: 8.99, isFeatured: false),
        Icon(name: "Sky icon", imageName: "sky", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
        Icon(name: "Toxic icon", imageName: "toxic", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
        Icon(name: "Book icon", imageName: "ic_book", description: "Colorful icon designed by Marin Begović.", price: 2.99, isFeatured: false),
        Icon(name: "Backpack icon", imageName: "ic_backpack", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
        Icon(name: "Camera icon", imageName: "ic_camera", description: "Colorful camera icon designed by Marin Begović.", price: 4.99, isFeatured: false),
        Icon(name: "Coffee icon", imageName: "ic_coffee", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: true),
        Icon(name: "Glasses icon", imageName: "ic_glasses", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
        Icon(name: "Icecream icon", imageName: "ic_ice_cream", description: "Colorful icon designed by Marin Begović.", price: 4.99, isFeatured: false),
        Icon(name: "Smoking pipe icon", imageName: "ic_smoking_pipe", description: "Colorful icon designed by Marin Begović.", price: 6.99, isFeatured: false),
        Icon(name: "Vespa icon", imageName: "ic_vespa", description: "Colorful icon designed by Marin Begović.", price: 9.99, isFeatured: false)
    ]
    
    enum Section {
        case all
    }
    
    lazy var dataSource = configureDatasource()
    
    private var shareEnabled = false
    private var selectedIcons: [(icon: Icon, snapshot: UIImage)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 150)
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 20
            layout.scrollDirection = .vertical
        }

        collectionView.dataSource = dataSource
        updateSnapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIconDetail" {
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! IconDetailViewController
                destinationController.icon = iconSet[indexPaths[0].row]
                collectionView.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showIconDetail" {
            if shareEnabled {
                return false
            }
        }
        return true
    }

    // MARK: UICollectionViewDataSource

    func configureDatasource() -> UICollectionViewDiffableDataSource<Section, Icon> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Icon>(collectionView: collectionView) { (collectionView, indexPath, icon) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
            cell.iconImageView.image = UIImage(named: icon.imageName)
            cell.iconPriceLabel.text = "$\(icon.price)"
            cell.backgroundView = (icon.isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : nil
            
            let selectedBackground = UIView()
            selectedBackground.layer.borderColor = UIColor.systemRed.cgColor
            selectedBackground.layer.borderWidth = 3.0
            cell.selectedBackgroundView = selectedBackground
            
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Icon>()
        snapshot.appendSections([.all])
        snapshot.appendItems(iconSet, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        guard shareEnabled else {
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareButton.title = "Done"
            shareButton.style = UIBarButtonItem.Style.plain
            
            return
        }
        
        guard selectedIcons.count > 0 else {
            return
        }
        
        let snapshots = selectedIcons.map { $0.snapshot }
        
        let activityController = UIActivityViewController(activityItems: snapshots, applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activityType, completed, returnedItem, error) in
//                 Deselect all selected items
                if let indexPaths = self.collectionView?.indexPathsForSelectedItems {
                    for indexPath in indexPaths {
                        self.collectionView?.deselectItem(at: indexPath, animated: false)
                    }
                }
            
//            Remove all items from selectedIcons array
            self.selectedIcons.removeAll(keepingCapacity: true)
            
//            Change the sharing mode to NO
            self.shareEnabled = false
            self.collectionView?.allowsMultipleSelection = false
            self.shareButton.title = "Share"
            self.shareButton.style = UIBarButtonItem.Style.plain
        }
        present(activityController, animated: true, completion: nil)
    }
}

extension IconCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard shareEnabled else {
            return
        }
        
        if let selectedIcon = dataSource.itemIdentifier(for: indexPath) {
            if let snapshot = collectionView.cellForItem(at: indexPath)?.snapshot {
                selectedIcons.append((icon: selectedIcon, snapshot: snapshot))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard shareEnabled else {
            return
        }
        
        if let deselectedIcon = dataSource.itemIdentifier(for: indexPath) {
    
            if let index = selectedIcons.firstIndex(where: { $0.icon.name == deselectedIcon.name }) {
                selectedIcons.remove(at: index)
            }
        }
    }
}
