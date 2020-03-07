//
//  DetailsViewController.swift
//  Shelesh_Demo
//
//  Created by Mac on 3/5/20.
//  Copyright © 2020 SheleshR. All rights reserved.
//

import Foundation
import UIKit
class DetailsViewController: UIViewController {
    var countryDetails : [String:Any]? = nil
    var isOffline = false
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
   
    @IBOutlet weak var lblCapital: UILabel!
    @IBOutlet weak var lblCallingCode: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblSubRegion: UILabel!
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        if(self.isOffline == true){
            self.navigationItem.rightBarButtonItem = nil
        }
        
        
        
        
        //self.imgView.image
        
        if let name = countryDetails!["name"] as? String{
            self.lblCountryName.text = name
            
        }
        if let capital = countryDetails!["capital"] as? String{
            self.lblCapital.text = capital
        }
        if let codes = countryDetails!["callingCodes"] as? [String]{
            if codes.count > 0{
                if let code = codes[0] as? String{
                    self.lblCallingCode.text = code
                }
            }
        }
        if let region = countryDetails!["region"] as? String{
            self.lblRegion.text = region
        }
        if let subregion = countryDetails!["subregion"] as? String{
            self.lblSubRegion.text = subregion
        }
        if let zones = countryDetails!["timezones"] as? [String]{
            if zones.count > 0{
                if let zone = zones[0] as? String{
                    self.lblTimeZone.text = zone
                }
            }
        }
        if let currencies = countryDetails!["currencies"] as? [Dictionary<String,Any>]{
            if currencies.count > 0{
                if let currency = currencies[0] as? Dictionary<String,Any>{
                    self.lblCurrency.text = currency["name"] as! String
                }
            }
        }
        if let langs = countryDetails!["languages"] as? [Dictionary<String,Any>]{
            if langs.count > 0{
                if let language = langs[0] as? Dictionary<String,Any>{
                    self.lblLanguage.text = language["name"] as! String
                }
            }
        }
        
        
        
    }
    
  @objc  func saveBtnClicked(sender:Any) -> Void {
        print("save clicked")
    
    
    
    
    let pref = UserDefaults.standard
    var ob1 = pref.object(forKey: "Countries") as? Data
    var obj:[Dictionary<String,Any>]? = nil
//    if(ob1 == nil){
//
 //   }
//    do {
//         obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ob1!) as? [Dictionary<String,Any>]
        
//    } catch {
//        return
 //   }
    
    if(ob1 == nil){
        
        var ar:[Dictionary<String,Any>] = []
        ar.append(self.countryDetails!)
        pref.removeObject(forKey: "Countries")
        
        do{
            let d = try NSKeyedArchiver.archivedData(withRootObject: ar, requiringSecureCoding: false)
            pref.set(d, forKey: "Countries")
        }catch{
            return
        }

    }else{
        
            do {
                 obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ob1!) as? [Dictionary<String,Any>]
                
            } catch {
                return
           }
        
        
        if (obj is [Dictionary<String,Any>]){
            if var ob = obj as? [Dictionary<String,Any>]
            {
                ob.append(self.countryDetails!)
                pref.removeObject(forKey: "Countries")

                do{
                    let d = try NSKeyedArchiver.archivedData(withRootObject: ob, requiringSecureCoding: false)
                    pref.set(d, forKey: "Countries")
                }catch{
                    return
                }
            }
        }
    }
 
    pref.synchronize()
    
    }
}
