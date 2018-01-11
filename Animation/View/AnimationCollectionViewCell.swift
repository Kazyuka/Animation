//
//  AnimationCollectionViewCell.swift
//  Animation
//
//  Created by Казюка Руслан Сергеевич on 10.01.18.
//  Copyright © 2018 Казюка Руслан Сергеевич. All rights reserved.
//

import UIKit
import FLAnimatedImage

@objc protocol AnimationCollectionViewCellDelegate: class {

    func showAnimation(_ image: FLAnimatedImageView)
}

class AnimationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var animationImageView: FLAnimatedImageView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGesture:)))
            animationImageView.isUserInteractionEnabled = true
            animationImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    weak var delegate: AnimationCollectionViewCellDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
    }
    
    var animation: Animation! {
       
        didSet {
            self.configureCell()
        }
    }
    
    func configureCell() {
        DispatchQueue.main.async {
            self.title.text = self.animation.title
            let im = FLAnimatedImage.init(gifData: self.animation.image)
            self.animationImageView.animatedImage = im
            self.animationImageView.stopAnimating()
        }
    }
    @objc func imageTapped(tapGesture: UITapGestureRecognizer)
    {
        let imageView = tapGesture.view as? FLAnimatedImageView
        self.delegate?.showAnimation(imageView!)
    }
}
