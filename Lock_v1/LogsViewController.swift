//
//  LogsViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 02/02/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayCount:Int = 0
    
    struct Item {
        let name : String
        let lockTime : String
        let type : String
    }
    /// cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    var items = [Item]()
    
    @IBOutlet weak var textUodate: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /// Do any additional setup after loading the view.
        let lockid = UserDefaults.standard.value(forKey: "LockID")!
        
        
        ///get the data from the server for that specific lock id
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/logs")!)
        request.httpMethod = "POST"
        let postString = "LockID=\(lockid)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                              print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                print(response ?? " ")
            }
            let responseString = String(data: data, encoding: .utf8)
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    self.arrayCount = (resString["message"].count)
                    print(self.arrayCount)
                    let returnedArray = resString["message"].arrayValue
                    for item in returnedArray {
                        let name = String(describing: item["name"])
                        let lockTime = String(describing: item["lockTime"])
                        let type = String(describing: item["type"])
                        self.items.append(Item(name:name, lockTime:lockTime, type:type))
                    }
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCount
    }
    /// create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let item = items[indexPath.row]
        
        let cellText = "\(item.name) \(item.type) At: \(item.lockTime) "
        
        cell.textLabel?.text = cellText
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:10)
        print(cellText)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    
    
    
    /**
     Display a message via an alert box
     */
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    
    
    
    
    // Do any additional setup after loading the view
    @IBOutlet weak var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Handle the back button
     */
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var welcomemessage: UILabel!
    
    
    
}
