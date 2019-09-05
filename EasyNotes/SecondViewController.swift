//
//  SecondViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-12.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var personalButton : UIButton!
    @IBOutlet var workButton : UIButton!
    @IBOutlet var important : UIButton!
    @IBOutlet var temporary : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       borderColorForButoon()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //to get border for button
    
    func borderColorForButoon(){
        personalButton.layer.borderWidth = 2.0
        personalButton.layer.borderWidth = 2.0
        personalButton.layer.borderColor = UIColor.lightGray.cgColor
        personalButton.layer.cornerRadius = 5.0
        workButton.layer.borderWidth = 2.0
        workButton.layer.borderWidth = 2.0
        workButton.layer.borderColor = UIColor.lightGray.cgColor
        workButton.layer.cornerRadius = 5.0
        important.layer.borderWidth = 2.0
        important.layer.borderWidth = 2.0
        important.layer.borderColor = UIColor.lightGray.cgColor
        important.layer.cornerRadius = 5.0
        temporary.layer.borderWidth = 2.0
        temporary.layer.borderWidth = 2.0
        temporary.layer.borderColor = UIColor.lightGray.cgColor
        temporary.layer.cornerRadius = 5.0
    }
  
    @IBAction func continueButtonClicked(){
        performSegue(withIdentifier: "goToNextPage", sender: nil)
    }
    @IBAction func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
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
