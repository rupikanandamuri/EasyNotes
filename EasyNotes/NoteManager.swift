//
//  NoteManager.swift
//  EasyNotes
//
//  Created by Venkata Nandamuri on 2019-09-17.
//  Copyright © 2019 Rupika. All rights reserved.
//

import Foundation
import RealmSwift

enum NoteType : String{
    case personal = "personal"
    case work = "work"
    case temporary = "temporary"
    case important = "important"
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
    
    var changePasswordMode : Bool = false
    var onBoardingFinished : Bool = false
    
    var fontSize : CGFloat = 12{
        didSet{
            if fontSize < 12 {
                fontSize = 12
            }
        }
    }
    
    //Why I used lazy here?
    lazy var noteFont = UIFont.systemFont(ofSize: fontSize)
    
    //One time initialising the database , this need not be a singleton
    let realm = try! Realm()
    
    private init() {
        print("Singleton initialized")
        print(realm.configuration.fileURL?.absoluteString ?? "no realm file url")
        onBoardingFinished = UserDefaults.standard.bool(forKey: "OnBoardingFinished")
    }
    
    func updateOnBoardingStatus(_ status : Bool){
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: "OnBoardingFinished")
    }
    
    func getColor(_ tag : String) -> UIColor{
        if let color = UserDefaults.standard.color(forKey: tag){
            return  color
        }else{
            if tag == NoteType.personal.rawValue{
                return UIColor.EasyNoteTheme.personalColor
            }
            if tag == NoteType.work.rawValue{
                return UIColor.EasyNoteTheme.workColor
            }
            if tag == NoteType.important.rawValue{
                return UIColor.EasyNoteTheme.impColor
            }
            if tag == NoteType.temporary.rawValue{
                return UIColor.EasyNoteTheme.temporaryColor
            }
        }
        return UIColor.EasyNoteTheme.personalColor
    }
    
    
    func saveColor(_ color : UIColor, _ tag : String){
        UserDefaults.standard.set(color, forKey: tag)
    }
    
    
    func deleteNote(_ note : Notes){
        try! realm.write {
            realm.delete(note)
        }
    }
    
    func addNote(_ note : Notes){
        //save in realm
        try! realm.write {
            realm.add(note, update: .all)
        }
    }
    
    func updateNote(_ note : Notes , _ notes : String){
        //save in realm
        try! realm.write {
            note.notes = notes
            //to get the date
            note.updatedDate = getCurrentDate()
            realm.add(note,update: .modified)
        }
    }
    
    func getNotes(_ tagType : NoteType, _ shouldSort : Bool, _ ascendingOrder : Bool) -> Results<Notes>?{
        let allData = realm.objects(Notes.self)
        //filter asccording to tag so that i will display in table view.
        var result = allData.filter("tag == %@",tagType.rawValue)
        if shouldSort{
            result = result.sorted(byKeyPath: "dateCreated",ascending: ascendingOrder)
        }
        return result
    }
    
    func getPersonalNoteCount() -> Int{
        let result = getNotes(.personal, false, false)
        return result?.count ?? 0
    }
    
    func getWorkNoteCount() -> Int{
        let result = getNotes(.work, false, false)
        return result?.count ?? 0
    }
    
    func getTempNoteCount() -> Int{
        let result = getNotes(.temporary, false, false)
        return result?.count ?? 0
    }
    
    func getImpNoteCount() -> Int{
        let result = getNotes(.important, false, false)
        return result?.count ?? 0
    }
    
    func getLastModifiedNote(_ tag : NoteType) -> String?{
        if var result = getNotes(tag, false, false){
            result = result.sorted(byKeyPath: "updatedDate",ascending: false)
            if let note = result.first{
                return note.updatedDate
            }
        }
        return .none
    }
    
    //Helper method
    func getCurrentDate() -> String{
        let rawDate = Date() //This will give the current date
        
        //NEdd to convert this into string format
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a, yyyy"
        
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
    
    func getPersonalPasscodeVc() -> PersonalPasswordViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToPersonal") as!  PersonalPasswordViewController
        return nextViewController
    }
    
    //to show notification on particular date and time in impoirtant tag
    // 0 - Once , 1- Daily, 2-Weekly, 3- Monthly, 4 - Yearly
    func scheduleNotification(date : Date, _ repeatMode : Int) {
        
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey this is Simplified iOS"
        content.subtitle = "iOS Development is fun"
        content.body = "We are learning about iOS Local Notification"
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        
        //let component = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute,.second], from: date)
        
        var component = DateComponents()
        var repeats = false
        if repeatMode > 0{
            repeats = true
        }
        
        if repeatMode == 0{
            component = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        }
        if repeatMode == 1{
          component = Calendar.current.dateComponents([.day,.hour,.minute,.second,], from: date)
        }
        if repeatMode == 2{
            component = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        }
        if repeatMode == 3{
            component = Calendar.current.dateComponents([.month,.hour,.minute,.second,], from: date)
        }
        if repeatMode == 4{
            component = Calendar.current.dateComponents([.year,.hour,.minute,.second,], from: date)
        }
        
        
        //If user want this to repeat every day, make repeats:true, else make it false
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: repeats)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            guard error == nil else { return }
             print("Notification scheduled")
        }
       
    }
    
    
    // MARK: Font related code
    func getBoldFont() -> UIFont{
        return UIFont.systemFont(ofSize: fontSize).bold()
    }
    
    func getItalicFont() -> UIFont{
        return UIFont.systemFont(ofSize: fontSize).italic()
    }
    
    func getBoldItalicFont() -> UIFont{
        return UIFont.systemFont(ofSize: fontSize).boldItalic()
    }
    
    func getNormalFont() -> UIFont{
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    
    
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: [.traitItalic, .traitBold])
    }

}

