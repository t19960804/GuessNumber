//
//  AlertController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/9/17.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import Foundation
import UIKit
struct AlertController {
    static func showBasicAlert(viewController: UIViewController,title: String,message: String){
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了",style: .default,handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            viewController.present(alert,animated: true,completion: nil)
        }
    }
    
}
