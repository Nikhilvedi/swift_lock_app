//
//  SetupViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 24/01/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import SwiftyJSON

class SetupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ///hide keyboard when anywhere tapped
         self.hideKeyboardWhenTappedAround()
       
        let n =  UserDefaults.standard.value(forKey: "email")!
        hello_label.text = "Hello \(n) you have no locks set up"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if    UserDefaults.standard.bool(forKey: "LockIDPresent") == true
        {
            self.dismiss(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBOutlet weak var LockID: UITextField!
    
    /**
     Setup the LockID of the user
     */
    @IBAction func setup(_ sender: Any) {
        
        if (UserDefaults.standard.value(forKey: "userIP") == nil)
        {
            UserDefaults.standard.set("localhost", forKey: "userIP")
            
            print("Local host programatically set");
        }
        

        let u = UserDefaults.standard.value(forKey: "userIP")!
        let name = UserDefaults.standard.value(forKey: "email")!
        UserDefaults.standard.synchronize()
        var request = URLRequest(url: URL(string: "http://\(u):3000/users/returnLockID")!)
        request.httpMethod = "POST"
        let postString = "LockID=\(LockID.text!)&name=\(name)"
        print(postString)
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
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    //dismiss window and set bool to true
                    print("works");
                    UserDefaults.standard.set(true, forKey: "LockIDPresent")
                    //set lockID in user defaults
                    UserDefaults.standard.set(self.LockID.text!, forKey: "LockID")
                     UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion: nil);
                    
                }
                else if resString["success"].stringValue == "false"
                {
                    print("failed")
                    print(resString["message"].stringValue)
                    
                }
               
            }
            
        }
    task.resume()
  
           }
    @IBOutlet weak var hello_label: UILabel!

    /**
     Handle the back button
     */
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
   }
