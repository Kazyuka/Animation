//
//  AnimationsViewController.swift
//  Animation
//
//  Created by Казюка Руслан Сергеевич on 10.01.18.
//  Copyright © 2018 Казюка Руслан Сергеевич. All rights reserved.
//

import UIKit
import Foundation
import FLAnimatedImage

class AnimationsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var animations: [Animation]!
    var filteredAnimations: [Animation]!
    var searchActive : Bool = false
    
    var startingFrame: CGRect?
    var blackBackgraundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSearchConntroller()
        self.loadDataForTableView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addSearchConntroller() {
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search animations by title"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func loadDataForTableView() {
        animations = CoreDtataHandler.getAnimationModelFromCoreData()
        
        if animations.count == 0 {
            
            ApiClient.sharedInstance.getAnimationByInputString(completion: { (dic) in
                
                CoreDtataHandler.saveAnimationModel(animationsArray: dic)
                self.animations = CoreDtataHandler.getAnimationModelFromCoreData()
                self.collectionView.reloadData()
                
            }, error: { (error) in
                 self.present(self.createAllertWithOneButton(title: error, message: " ", buttonTitle: "ok"), animated: true, completion: nil)
            })
        }
    }
}

extension AnimationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredAnimations.count
        } else {
            return animations.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? AnimationCollectionViewCell
        cell?.delegate = self
        if searchController.isActive && searchController.searchBar.text != "" {
            cell!.animation = filteredAnimations[indexPath.item]
        } else {
            cell!.animation = animations[indexPath.item]
        }
        return cell!
    }
    
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let cellImage = cell as? AnimationCollectionViewCell
       cellImage?.animationImageView.startAnimating()
    }
}

extension AnimationsViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text{
            filterContent(searchText: searchText)
            collectionView.reloadData()
        }
    }
    func filterContent(searchText:String) {
        
        if let animationsArray = animations {
            filteredAnimations = animationsArray.filter({ (animation) -> Bool in
                let animationTitle = animation.title?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                return animationTitle != nil
            })
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
}

extension AnimationsViewController: AnimationCollectionViewCellDelegate {
    
    func showAnimation(_ image: FLAnimatedImageView) {
        
        startingFrame = image.superview?.convert(image.frame, to: nil)
        let zommingView = FLAnimatedImageView.init(frame: startingFrame!)
        
        zommingView.animatedImage = image.animatedImage
        zommingView.isUserInteractionEnabled = true
        zommingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(tapGesture:))))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgraundView = UIView(frame: keyWindow.frame)
            blackBackgraundView?.backgroundColor = UIColor.black
            keyWindow.addSubview(blackBackgraundView!)
            keyWindow.addSubview(zommingView)
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                zommingView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zommingView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgraundView?.backgroundColor = UIColor.clear
            }, completion: { (bool) in
                zoomOutImageView.removeFromSuperview()
                self.blackBackgraundView?.removeFromSuperview()
            })
        }
    }
}

