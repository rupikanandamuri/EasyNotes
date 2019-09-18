//
//  DashboardViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-13.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardViewController: UIViewController {
    
    @IBOutlet var personalView : UIView!
    @IBOutlet var workView : UIView!
    @IBOutlet var temporaryView : UIView!
    @IBOutlet var importantView : UIView!
    @IBOutlet var personalNotesCount : UILabel!
    @IBOutlet var workNotesCount : UILabel!
    @IBOutlet var temporaryNotesCount : UILabel!
    @IBOutlet var importantNotesCount : UILabel!
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NoteManager.shared.deleteExpiredNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        countNotesInEachCategory()
    }
    
    
    @IBAction func addNotesButtonClicked(){
        performSegue(withIdentifier: "addNotes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNotes" {
            if let vc = segue.destination as? addNotesViewController{
                if  sender == nil {
                    vc.isNewNote = true
                }
            }
        }
    }
    
    //to display no of notes in every catergory count label
    func countNotesInEachCategory(){
        personalNotesCount.text = String(NoteManager.shared.getPersonalNoteCount())
        workNotesCount.text = String(NoteManager.shared.getWorkNoteCount())
        temporaryNotesCount.text = String(NoteManager.shared.getTempNoteCount())
        importantNotesCount.text = String(NoteManager.shared.getImpNoteCount())
    }
    
    
    @IBAction func addPersonalButtonClicked(){
  
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToPersonal") as!  PersonalPasswordViewController
             nextViewController.tagColor = personalView.backgroundColor
            self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func addWorkButtonClicked(){
       showTableController("work")
    }
  
    @IBAction func addTemporaryButtonClicked(){
        showTableController("temporary")
    }
    
    @IBAction func addImportantButtonClicked(){
         showTableController("important")
    }
    
    func showTableController(_ tag : String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! NoteListInTableViewController
        nextViewController.tagColor = getColorForTag(tag)
        nextViewController.tagType = tag
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func getColorForTag(_ tag : String) -> UIColor?{
        switch tag {
        case "temporary":
                 return temporaryView.backgroundColor
        case "important":
            return importantView.backgroundColor
        case "work":
            return workView.backgroundColor
        case "personal" :
            return personalView.backgroundColor
        default:
           return  UIColor.white
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
