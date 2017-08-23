//
//  UIView + Extension.swift
//  InformTestProject
//
//  Created by IvanLazarev on 23/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

