//
//  FavoriteBarButtonItem.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 02/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import UIKit

class FavoriteBarButtonItem : UIBarButtonItem {
    
    
    private var button : UIButton!
    var imageDelegate : BarButtonImageDelegate! {
        didSet {
            self.setImage()
        }
    }
    
    override init() {
        super.init()
        self.button = UIButton(type: .custom)
        self.button.addTarget(self, action: #selector(FavoriteBarButtonItem.update), for: UIControlEvents.touchUpInside)
        self.button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        self.button.setImage(UIImage(named: "favicon-disabled"), for: .normal)
        self.customView = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func update() {
        self.imageDelegate.willUpdateFavorite()
        self.setImage()
    }
    
    private func setImage() {
        if self.imageDelegate.shouldChangeImage() {
            self.button.setImage(UIImage(named: "favicon-enabled"), for: .normal)
        } else {
            self.button.setImage(UIImage(named: "favicon-disabled"), for: .normal)
        }

    }
    
    
    
}
