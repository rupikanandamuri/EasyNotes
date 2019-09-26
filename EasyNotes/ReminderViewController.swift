//
//  ReminderViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-09-25.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

    @IBOutlet var datePicker : UIDatePicker!{
        didSet{
            datePicker.datePickerMode = .dateAndTime
        }
    }
    
    @IBOutlet weak var prioritySegment : UISegmentedControl!
    @IBOutlet weak var repeatSegment : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneNotes))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
    }
    @objc func doneNotes(){
        print("done button clicked")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func datePickerClicked(){
        NoteManager.shared.scheduleNotification(date: datePicker.date, repeatSegment.selectedSegmentIndex)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller sing segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
