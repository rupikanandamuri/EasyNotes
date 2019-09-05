//
//  PersonalPasswordViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-12.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class PersonalPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var firstTextField : UITextField!
    @IBOutlet var secondTextField : UITextField!
    @IBOutlet var thirdTextField : UITextField!
    @IBOutlet var fourthTextField : UITextField!
    @IBOutlet var continueButton : UIButton!
    @IBOutlet var skipButton : UIButton!
   @IBOutlet var titleLabel : UILabel!
   
    
    var dataSource = [String]()
    let defaults    = UserDefaults.standard
    var tagColor : UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
       
        // Do any additional setup after loading the view.
        firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        //for aliging tetx on center
        textAlignmetCenter()
        continueButton.isEnabled = false
        //for skip button enabled while onboarding and diable in other cases.
        if navigationController?.viewControllers[1] is SecondViewController && navigationController?.viewControllers.count             == 3{
         skipButton.isEnabled = true
        }
        else{
            skipButton.isHidden = true
            titleLabel.text = "Enter your personal passcode"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
         dataSource.removeAll()
        
    }
    
    func textAlignmetCenter(){
        firstTextField.textAlignment = .center
        firstTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48.0)
        secondTextField.textAlignment = .center
        secondTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48.0)
        thirdTextField.textAlignment = .center
        thirdTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48.0)
        fourthTextField.textAlignment = .center
        fourthTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48.0)
    }
 //for skip button
    @IBAction func skipButtonClicked(){
        if navigationController?.viewControllers[1] is SecondViewController && navigationController?.viewControllers.count             == 3{
            //Coming from first onboarding
            performSegue(withIdentifier: "skipgoToDashboard", sender: nil)
      }
    }
    
    //to check userdefault contain value or not
    func contains(key: String) -> Bool {
        return UserDefaults.standard.value(forKey: "password") != nil
    }
    @IBAction func continueButtonClicked(){
        
        //appending all the text filed text into one array
        dataSource.append(firstTextField.text ?? "0")
        dataSource.append(secondTextField.text ?? "0")
        dataSource.append(thirdTextField.text ?? "0")
        dataSource.append(fourthTextField.text ?? "0")
        let str1 = dataSource.joined()
        
        if   navigationController?.viewControllers[1] is SecondViewController && navigationController?.viewControllers.count             == 3 {
            performSegue(withIdentifier: "Confirmpassword", sender: dataSource)
        }
        else{
            
             //if getPassword == str1{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! DisplayNotesWithinTableViewController
            nextViewController.tagType = "personal"
            nextViewController.tagColor = tagColor
            self.navigationController?.pushViewController(nextViewController, animated: true)
            print(dataSource)
            //}
        }

    }
    //sending tetxfile values to next contoller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "Confirmpassword")
        {
            let obj = segue.destination as! ChoosePersonPassViewController
            obj.selectedText = sender as? [String] ?? ["0"]
            
        }
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
    //to move cursor from one text field to other
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if let lastChar = text?.last{
             textField.text = String(lastChar)
        }
        if  textField.text?.count  == 1 {
            switch textField{
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                thirdTextField.becomeFirstResponder()
            case thirdTextField:
                fourthTextField.becomeFirstResponder()
            case fourthTextField:
                fourthTextField.resignFirstResponder()
                if let getPassword = UserDefaults.standard.string(forKey: "password") {
                   continueButton.isEnabled = true
                }
            default:
                break
            }
        }
        if  textField.text?.count == 0 {
            switch textField{
            case firstTextField:
                firstTextField.becomeFirstResponder()
            case secondTextField:
                firstTextField.becomeFirstResponder()
            case thirdTextField:
                secondTextField.becomeFirstResponder()
            case fourthTextField:
                thirdTextField.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            print("cursor not entered into text field")
        }
    }

}

