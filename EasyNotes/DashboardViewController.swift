//
//  DashboardViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-13.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet var personalView : UIView!
    @IBOutlet var workView : UIView!
    @IBOutlet var temporaryView : UIView!
    @IBOutlet var importantView : UIView!
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func addNotesButtonClicked(){
        performSegue(withIdentifier: "addNotes", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNotes" {
            if let vc = segue.destination as? Dashboard2ViewController{
                if  sender == nil {
                    vc.isNewNote = true
                }
            }
        }
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
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! DisplayNotesWithinTableViewController
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
