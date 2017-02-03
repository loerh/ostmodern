//
//  Alert.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 01/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    class func networkDidFailToConnect(viewController vc : UIViewController) {
        let alertController = UIAlertController(title: "Error", message: "It seems you are not connected. Content you see might not be up to date. Please connect to network and try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
    }
    
}
