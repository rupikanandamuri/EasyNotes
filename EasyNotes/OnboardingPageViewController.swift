//
//  ViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-12.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    //for changing the color of uilabel text
    var myString:NSString = "EasyNote.."
    var myMutableString = NSMutableAttributedString()
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var firstView : UIView!
    @IBOutlet var secondView : UIView!
    @IBOutlet var thirdView : UIView!
   
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Mark : to get orange color for  easy text in label
       myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location:0,length:4))
        // set label Attribute
        titleLabel.attributedText = myMutableString
       //adding border to views
        firstView.layer.borderWidth = 2.0
        firstView.layer.borderColor = UIColor.lightGray.cgColor
        firstView.layer.cornerRadius = 5
        secondView.layer.borderWidth = 2.0
        secondView.layer.borderColor = UIColor.lightGray.cgColor
        secondView.layer.cornerRadius = 5
        thirdView.layer.borderWidth = 2.0
        thirdView.layer.borderColor = UIColor.lightGray.cgColor
        thirdView.layer.cornerRadius = 5
        
        //to change color in dark mode for the views
        if traitCollection.userInterfaceStyle == .dark{
                   firstView.layer.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0).cgColor
                   secondView.layer.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0).cgColor
                   thirdView.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
               }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func continueButtonClicked(){
        performSegue(withIdentifier: "goToNext", sender: nil)
    }
}

