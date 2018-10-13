//
//  ErrorHandle.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/10/13.
//  Copyright © 2018 t19960804. All rights reserved.
//

import Foundation

struct ErrorHandle {
    enum Errors : String{
        case userNameWasUsed = "The email address is already in use by another account."
        case internetDisconnect = "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
        
    }
}
