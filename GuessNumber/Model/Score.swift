//
//  Score.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/8/11.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import Foundation
import RealmSwift
class Score: Object {
    @objc dynamic var score: String = ""
    @objc dynamic var mode: String = ""
    var parentUser = LinkingObjects(fromType: User.self, property: "scores")
}
