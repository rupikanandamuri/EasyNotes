//
//  SettingsViewController.swift
//  EasyNotes
//
//  Created by Venkata Nandamuri on 2019-09-18.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsListView : UITableView!
    
    var datasource = [Setting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        datasource.append(Setting(title: "Change Password", image: UIImage(named: "password")!))
        datasource.append(Setting(title: "Change Color", image: UIImage(named: "paint")!))
        datasource.append(Setting(title: "Notifications", image: UIImage(named: "notifications")!))
        datasource.append(Setting(title: "Refer EasyNote", image: UIImage(named: "link")!))
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsListView.reloadData()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell{
            let setting = datasource[indexPath.row]
            cell.settingsIcon.image = setting.image
            cell.settingsLabel.text = setting.title
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            showPasswordView()
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "showColorPicker", sender: nil)
        }
        if indexPath.row == 2{
            
        }
        if indexPath.row == 3{
            
        }
    }
    
    func showPasswordView(){
        let nextViewController = NoteManager.shared.getPersonalPasscodeVc()
        NoteManager.shared.changePasswordMode = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}

class SettingsCell: UITableViewCell {
    @IBOutlet weak var settingsIcon : UIImageView!
    @IBOutlet weak var settingsLabel : UILabel!
}


struct Setting{
    let title : String
    let image : UIImage
}
