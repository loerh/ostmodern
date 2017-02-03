//
//  BarButtonImageDelegate.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 03/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation

protocol BarButtonImageDelegate {
    func shouldChangeImage() -> Bool
    func willUpdateFavorite()
}
