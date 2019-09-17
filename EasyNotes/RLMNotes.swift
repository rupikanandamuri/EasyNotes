//
//  Produtc.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-20.
//  Copyright © 2019 Rupika. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Notes: Object {
    @objc dynamic var notes = ""
    @objc dynamic var tag = ""
    @objc dynamic var dateCreated = ""
    @objc dynamic var updatedDate = ""
    @objc dynamic var expireDate = "" //By defualt we are giving empty string
    @objc dynamic var noteID = NSUUID().uuidString  // unique ID
 
    override static func primaryKey() -> String? {
        return "noteID"
    }
}

