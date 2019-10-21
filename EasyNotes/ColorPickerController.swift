//
//  ColorPickerController.swift
//  EasyNotes
//
//  Created by Venkata Nandamuri on 2019-09-18.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit
import DynamicColor

class ColorPickerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagTableView : UITableView!
    @IBOutlet weak var primaryColorListView : UITableView!
    @IBOutlet weak var secondaryColorListView : UITableView!
    
    var primaryColors = [[UIColor]]()
    var secondaryColors = [UIColor]()
    var tagSelected : String?
    var selectedColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadColorPalette()
        primaryColorListView.isHidden = true
        secondaryColorListView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (tagSelected != nil) && (selectedColor != nil){
            NoteManager.shared.saveColor(selectedColor!,tagSelected!)
        }
    }
    
    func loadColorPalette(){
        if let path = Bundle.main.path(forResource: "colors", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                    // do stuff
                    for key in jsonResult.keys{
                        if let hexColors = jsonResult[key] as? [String]{
                            var palette = [UIColor]()
                            for hexColor in hexColors{
                                let color = UIColor(hexString: "#\(hexColor)")
                                palette.append(color)
                            }
                            primaryColors.append(palette)
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
    func loadSecondaryColorPalette(_ color : UIColor){
        secondaryColors.removeAll()
      
        var i : CGFloat = 0.0
        var original = color
        for _ in 0...5{
            secondaryColors.append(color.lighter(amount: i))
            i += 0.07
            print(i)
        }
        secondaryColors.reverse()
        i = 0
        for _ in 0...5{
            secondaryColors.append(color.darkened(amount: i))
            i += 0.06
            print(i)
        }
        
        
        secondaryColorListView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tagTableView{
            return 1
        }
        if tableView == primaryColorListView{
            return primaryColors.count
        }
        if tableView == secondaryColorListView{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tagTableView{
            return 4
        }
        if tableView == primaryColorListView{
            let pallete = primaryColors[section]
            return pallete.count
        }
        if tableView == secondaryColorListView{
            return secondaryColors.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tagTableView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as? TagCell{
                if indexPath.row == 0{
                    cell.tagName.text = NoteType.personal.rawValue
                }
                if indexPath.row == 1{
                    cell.tagName.text = NoteType.work.rawValue
                }
                if indexPath.row == 2{
                     cell.tagName.text = NoteType.temporary.rawValue
                }
                if indexPath.row == 3{
                     cell.tagName.text = NoteType.important.rawValue
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        if tableView == primaryColorListView{
            let pallete = primaryColors[indexPath.section]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "primaryColorCell", for: indexPath) as? PrimaryColorCell{
                let color = pallete[indexPath.row]
                cell.colorView.backgroundColor = color
                cell.colorView.applyRadius()
                cell.selectionStyle = .none
                return cell
            }
           
        }
        if tableView == secondaryColorListView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "secondaryColorCell", for: indexPath) as? SecondaryColorCell{
                cell.colorView.applyRadius()
                let color = secondaryColors[indexPath.row]
                cell.colorView.backgroundColor = color
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tagTableView{
            return 60
        }
       
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tagTableView{
            if let cell = tableView.cellForRow(at: indexPath) as? TagCell{
                cell.contentView.applyBorderAndRadius()
                tagSelected = cell.tagName.text
                primaryColorListView.isHidden = false
                secondaryColorListView.isHidden = false
            }
        }
        if tableView == primaryColorListView{
            if let cell = tableView.cellForRow(at: indexPath) as? PrimaryColorCell{
                cell.colorView.applyBorderAndRadius()
                loadSecondaryColorPalette(cell.colorView.backgroundColor ?? UIColor.white)
                selectedColor = cell.colorView.backgroundColor
            }
        }
        if tableView == secondaryColorListView{
            if let cell = tableView.cellForRow(at: indexPath) as? SecondaryColorCell{
                cell.colorView.applyBorderAndRadius()
                selectedColor = cell.colorView.backgroundColor
            }
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

extension UIColor {
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
   
}

class TagCell : UITableViewCell{
    @IBOutlet weak var tagName : UILabel!
}
class PrimaryColorCell: UITableViewCell{
    @IBOutlet weak var colorView : UIView!
}
class SecondaryColorCell : UITableViewCell{
    @IBOutlet weak var colorView : UIView!
}

extension UserDefaults {

    func color(forKey key: String) -> UIColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}
