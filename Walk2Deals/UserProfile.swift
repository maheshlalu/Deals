//
//  UserProfile.swift
//  Walk2Deals
//
//  Created by apple on 14/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import Foundation
import RealmSwift

class UserProfile: Object {
    
    dynamic  var  name : String = ""
    dynamic  var  age : String = ""
    dynamic  var city :  String = ""
    dynamic  var  state : String = ""
    dynamic  var email :  String = ""
    dynamic  var gender :  String = ""
    dynamic  var image :  String = ""
    dynamic  var bannerImger :  String = ""

    dynamic  var firstName :  String = ""
    dynamic  var lastName :  String = ""
    dynamic  var userId :  String = ""
    dynamic  var aDharNumbers :  String = ""
    dynamic  var mobile :  String = ""

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
