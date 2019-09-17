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

extension UIColor {
    struct EasyNoteTheme {
        static var personalColor =  UIColor(red:0.30, green:0.81, blue:0.33, alpha:0.5)
        static var workColor = UIColor(red: 1.0, green: 156.0 / 255.0, blue: 62.0 / 255.0, alpha: 0.5)
        static var temporaryColor = UIColor(red: 91.0 / 255.0, green: 151.0 / 255.0, blue: 233.0 / 255.0, alpha: 0.5)
        static var impColor = UIColor(red: 253.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0, alpha: 0.5)
    }
}

class NoteManager {
    
    //This is a singleton reference, so all calls to the NoteManager class will be called on shared. Since this is singelton, all calls will share the same reference and will not be creating a new refernce for each call
    public static let shared = NoteManager()
    
    //One time initialising the database , this need not be a singleton
    let realm = try! Realm()
    
    private init() {
        print("Singleton initialized")
        print(realm.configuration.fileURL?.absoluteString ?? "no realm file url")
    }
    
    func deleteNote(_ note : Notes){
        try! realm.write {
            realm.delete(note)
        }
    }
    
    func addNote(_ note : Notes){
        //save in realm
        try! realm.write {
            realm.add(note,update: false)
        }
    }
    
    func updateNote(_ note : Notes , _ notes : String){
        //save in realm
        try! realm.write {
            note.notes = notes
            //to get the date
            note.updatedDate = getCurrentDate()
            realm.add(note,update: true)
        }
    }
    
    func getNotes(_ tagType : String, _ shouldSort : Bool, _ ascendingOrder : Bool) -> Results<Notes>?{
        let allData = realm.objects(Notes.self)
        //filter asccording to tag so that i will display in table view.
        var result = allData.filter("tag == %@",tagType)
        if shouldSort{
            result = result.sorted(byKeyPath: "dateCreated",ascending: ascendingOrder)
        }
        return result
    }
    
    func getPersonalNoteCount() -> Int{
        let result = getNotes("personal", false, false)
        return result?.count ?? 0
    }
    
    func getWorkNoteCount() -> Int{
        let result = getNotes("work", false, false)
        return result?.count ?? 0
    }
    
    func getTempNoteCount() -> Int{
        let result = getNotes("temporary", false, false)
        return result?.count ?? 0
    }
    
    func getImpNoteCount() -> Int{
        let result = getNotes("important", false, false)
        return result?.count ?? 0
    }
    
    //Helper method
    func getCurrentDate() -> String{
        let rawDate = Date() //This will give the current date
        
        //NEdd to convert this into string format
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
        let convertedString = formatter.string(from: rawDate)
        return convertedString
        
    }
    
    //Helper method
    func getExpiryDate() -> String?{
        
        let currentDate = Date() // This will get the current Date in raw Date type format
        //Need to add 7 days to this date
        if let expiryRawDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate){
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            let formattedStringDate = formatter.string(from: expiryRawDate)
            return formattedStringDate
        }
        return .none
    }
    
    
    //to check whether the notes is expired or not for temporoay tag the notes should be within 7 days if it more than 7 days if it is expiried  then we are delteting the notes.
    func deleteExpiredNotes(){
        let allData = realm.objects(Notes.self)
        //filter asccording to expiry date  so that i will display in table view.
        let  dataSource = allData.filter("(tag == 'temporary') and (expireDate != '')") //so we check for non empty strings in the expireDate field
        
        if dataSource.count > 0{
            
            //check if each note is expired or not
            for note in dataSource{
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                if  let expireRawDate = formatter.date(from: note.expireDate){
                    //comprae this date to current date
                    if expireRawDate > Date(){
                        // note isnt expired yet
                    }else{
                        //note is expired
                        //We can delete the note here
                        deleteNote(note)
                    }
                }
            }
        }
    }
    
}
