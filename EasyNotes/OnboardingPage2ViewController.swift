//
//  SecondViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-12.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class OnboardingPage2ViewController: UIViewController {

    @IBOutlet var personalButton : UIButton!
    @IBOutlet var workButton : UIButton!
    @IBOutlet var important : UIButton!
    @IBOutlet var temporary : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       customiseButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //to get border for button
    
    func customiseButtons(){
        personalButton.applyBorder()
        workButton.applyBorder()
        important.applyBorder()
        temporary.applyBorder()
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

extension UIButton{
    
    func applyBorder(){
        self.layer.borderWidth = 2.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
    }
}
