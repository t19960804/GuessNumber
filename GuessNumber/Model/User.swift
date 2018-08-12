//
//  UserModel.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/7/30.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import Foundation
import RealmSwift
class User: Object{
    @objc dynamic var userName: String = ""
    var scores = List<Score>()
    
}
