//
//  ViewController.swift
//  Shelesh_Demo
//
//  Created by Mac on 3/5/20.
//  Copyright © 2020 SheleshR. All rights reserved.
//

import UIKit
import SDWebImage
//import SDWebImageSVGCoder

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var arrData = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getCountries(text: "c")
        
        
    }
//MARK: Other functions
    func getCountries(text:String){
        var txt = text.replacingOccurrences(of: " ", with: "%20")
        
    var urlStr = "https:restcountries.eu/rest/v2/name/\(txt)"
        let url = URL(string: urlStr)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, urlResponse, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let d = data{
                    print("Data:\(d)")
                    do{
                        let json =  try JSONSerialization.jsonObject(with: d, options: [])
                        if json is Dictionary<String,Any> {
                            //print("Dictionary")
                            self.arrData = []
                            
                        }else{
                            //print("Array")
                            self.arrData = json as! [Dictionary<String,Any>]
                        }
                        
                        
                       //
                        
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                        }
                        
                        
                    }catch let e{
                        print("JSON Error:\(e.localizedDescription)")
                    }
                }else{
                    print("No Data found.")
                }
            }
        }
        dataTask.resume()
        
        
        
        
        
    }

}
//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
       
        if(SharedData.shared.isReachable){
            self.getCountries(text: searchText)
        }else{
            let pref = UserDefaults.standard
            var ob1 = pref.object(forKey: "Countries") as? Data
            
            if (ob1 == nil){
                self.arrData = []
                self.tblView.reloadData()
                return
            }else{
                var obj:[Dictionary<String,Any>]? = nil
                do{
                    obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ob1!) as? [Dictionary<String,Any>]
                }catch{
                    self.arrData = []
                    self.tblView.reloadData()
                    return
                }
                if (obj is [Dictionary<String,Any>]){
                    if var ob = obj as? Array<Any> //[Dictionary<String,Any>]
                    {
                        //self.arrData = ob
                        //let filteredArray = ob.filter() { $0.nativeName  == "1" }
                        
                        let predicate = NSPredicate(format: "nativeName contains[c] %@", searchText)
                        self.arrData = ob.filter({predicate.evaluate(with: $0) }) as! [Dictionary<String, Any>]
                       // self.arrData = ob.filter{predicate.evaluate(with: ($0)} as! [Dictionary<String, Any>]
                            self.tblView.reloadData()
                     
                        
                        
                        
                        
                        
                        
                    }
                }else{
                    self.arrData = []
                }
                self.tblView.reloadData()
                return
            }
        }
        
 
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let c = self.arrData.count
        
        
        return c
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tblView.dequeueReusableCell(withIdentifier: "CountryCellIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "CountryCellIdentifier")
        }
        let dic = self.arrData[indexPath.row]
        let strUrl = dic["flag"] as! String
        var imgUrl = NSURL(string:strUrl)



        cell?.textLabel?.text = dic["nativeName"] as! String
                
        cell?.imageView?.sd_setImage(with: imgUrl as URL?, placeholderImage: UIImage(named: "default"), options: .continueInBackground, completed: { (img, err, type, url) in
            
        })
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         let dic = self.arrData[indexPath.row]
        
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.countryDetails = dic
        if(self.searchBar.text == ""){
            vc.isOffline = true
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
