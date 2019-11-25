//
//  DisplayNotesWithinTableViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-20.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit
import  RealmSwift

class NoteListInTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
    @IBOutlet var tableView : UITableView!
    @IBOutlet var backButton : UIButton!
   var dataSource :  Results<Notes>?
    var tagColor : UIColor?
    var tagType  : NoteType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "DisplayNotesInTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesCell")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
        if let tagType = tagType{
           dataSource =  NoteManager.shared.getNotes(tagType, true, false)
        }
       tableView.reloadData()
    }
    
//for back button to go back to dash board.
    @IBAction func backButtonClicked(){
//        if  let vc = navigationController?.viewControllers[4]  {
//            navigationController?.popToViewController(vc, animated: true)
//        }
        if let vc = navigationController?.viewControllers.filter({ $0 is UITabBarController }).first {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! DisplayNotesInTableViewCell
        if let selectedNote = dataSource?[indexPath.row]{
              cell.notesFirstLabel.text = selectedNote.notes
              cell.dateLabel.text = selectedNote.dateCreated
              cell.viewBackground.backgroundColor = tagColor
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let selectedNote = dataSource?[indexPath.row]{
            performSegue(withIdentifier: "goToFinalNotes", sender: selectedNote)
        }
    }
    //this is used when u click on table view cell it should go to notes page contains data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFinalNotes" {
            if let vc = segue.destination as? addNotesViewController{
                if let temp =  sender as? Notes{
                    vc.myNote = temp
                    vc.isNewNote = false
                    vc.isdefault = false
                    vc.tagTypeInSelectedNotes = NoteType(rawValue: temp.tag)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    //MARK - caneditrowat and editing style is used to create delte when swipe left in table view.
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if  let selectNotes = dataSource?[indexPath.row]{
                NoteManager.shared.deleteNote(selectNotes)
                self.tableView.reloadData()
            }

        }
    }
    //MARK - when u click on add notes button in table view cell we are going to notes copntroller using storyboard id.
    @IBAction func addNotesButtonClicked(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WriteNewNotes") as! addNotesViewController
         nextViewController.isNewNote = true
        nextViewController.isAddNoteFromTable = true
        nextViewController.tagTypeInSelectedNotes = tagType
        nextViewController.isdefault = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
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
