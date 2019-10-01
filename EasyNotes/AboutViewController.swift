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
        textView.text = "Personal: The notes with personal tag are passcode protected. You can set passcode in two ways, while onboarding you can select passcode, if you skip that you may set it again before reading the personal notes. You can always change the passcode from the settings tab.\n \nWork : The notes with work tag can be shared via email or SMS. \n\nTemporary : The notes with temporary tag will be deleted automatically after 7 days,you can also call temporary notes as quick notes. \n\nImportant : The notes with important tag will get reminder depends up on the selected date or time by the user."
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
