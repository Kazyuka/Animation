//
//  UIView+Extentions.swift
//  Animation
//
//  Created by Руслан Казюка on 11.01.2018.
//  Copyright © 2018 Казюка Руслан Сергеевич. All rights reserved.
//

import Foundation
import  UIKit

extension UIViewController {
    
    func createAllertWithOneButton(title: String, message: String, buttonTitle:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default) {
            UIAlertAction in }
        alert.addAction(okAction)
        return alert
    }
}
