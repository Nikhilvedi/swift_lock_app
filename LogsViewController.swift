//
//  LogsViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 02/02/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogsViewController: UIViewController {

    @IBOutlet weak var updateText: UITextView!
    
    @IBOutlet weak var textUodate: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up variables
        let lockid = UserDefaults.standard.value(forKey: "LockID")!
        let email = UserDefaults.standard.value(forKey: "email")!
        
                let update = updateText;
        
        //welcome message for the lock ID
        
        welcomemessage.text = "Showing Lock/Unlock data for: \(email)"
        
        //et the data from the server for that specific lock id
        
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
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                  //  save the data to be manipulated and stored in table somehow
                    let returned_name =  resString["message"].arrayValue.map({$0["name"].stringValue})
                    let returned_time =  resString["message"].arrayValue.map({$0["lockTime"].stringValue})
                    let returned_type =  resString["message"].arrayValue.map({$0["type"].stringValue})
                    
                    print(returned_name);
                    print(returned_time);
                     print(returned_type);
                    DispatchQueue.main.async() {
                        update!.text = "\(returned_name.description), \(returned_type.description), \(returned_time.description)"
                        
                }
                    
                }
                else if resString["success"].stringValue == "false"
                {
                     DispatchQueue.main.async() {
                    self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
            
            }
            
        }
        task.resume()
    }
    

  
    
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }

        //post to server to get all logs for the specific lockID
        

        // Do any additional setup after loading the view

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBOutlet weak var welcomemessage: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
