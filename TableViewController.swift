//
//  TableViewController.swift
//  
//
//  Created by Nikhil vedi on 28/03/2017.
//
//

import UIKit
import SwiftyJSON

class TableViewController: UIViewController {

    struct Item {
        let name : String
        let lockTime : String
        let type : String
    }
    
    override func viewDidLoad() {
    
        var items = [Item]()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let lockid = UserDefaults.standard.value(forKey: "LockID")!
     //   let email = UserDefaults.standard.value(forKey: "email")!
        

        //get the data from the server for that specific lock id
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/logs")!)
        request.httpMethod = "POST"
        let postString = "LockID=\(lockid)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                  print(response ?? <#default value#>)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            //   print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    
                    let returnedArray = resString["message"].arrayValue
                    for item in returnedArray {
                        let name = String(describing: item["name"]) 
                        let lockTime = String(describing: item["lockTime"])
                        let type = String(describing: item["type"])
                        items.append(Item(name:name, lockTime:lockTime, type:type))
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                  print(resString["success"].stringValue)
                }
                
            }
            
        }
        task.resume()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
