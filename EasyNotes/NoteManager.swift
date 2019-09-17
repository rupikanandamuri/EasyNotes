//
//  NoteManager.swift
//  EasyNotes
//
//  Created by Venkata Nandamuri on 2019-09-17.
//  Copyright © 2019 Rupika. All rights reserved.
//

import Foundation
import RealmSwift

enum NoteType{
   case personal, work, temporary, important
}

class NoteManager {
    public static let shared = NoteManager()
    
}
