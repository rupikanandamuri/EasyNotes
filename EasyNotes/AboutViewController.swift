//
//  AboutViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-09-30.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var textView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        displayText()
    }
    func displayText(){
        textView.text = "Personal: The notes with personal tag are password protected. You can set password in two ways, while onboarding you can select password, if you skip that u can also select password when you are entering from Dashboard.\n \nWork : The note with work tag can share via email so that it will be easy to assign tasks. \n\nTemporary : The notes with temporary tag will be deleted automatically after 7 days,you can also call temporary notes as quick notes. \n\nImportant : The notes with important tag will get reminder depends up on the selected date or time by the user."
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
