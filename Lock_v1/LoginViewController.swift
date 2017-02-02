//
//  LoginViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 22/01/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when anywhere tapped
         self.hideKeyboardWhenTappedAround()
       // email.borderStyle = UITextBorderStyle.none;
     //   password.borderStyle = UITextBorderStyle.none;


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login()
    {
        
        UserDefaults.standard.set(email.text!, forKey: "email")
        UserDefaults.standard.set(password.text!, forKey: "password")
        UserDefaults.standard.synchronize()
        
        if (UserDefaults.standard.value(forKey: "userIP") == nil)
        {
            //make this a message box and stop the program crashing by assigning user defaults a value
            UserDefaults.standard.set("localhost", forKey: "userIP")

            print("Local host programatically set");
            displayMyAlertMessage("There is no IP set up, please see admin tools")
        }

        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/users/authenticate")!)
        request.httpMethod = "POST"
        let postString = "name=\(email.text!)&password=\(password.text!)"
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
                    
                    //save token to user standards
                    UserDefaults.standard.set((resString["token"].stringValue), forKey: "token")
                    UserDefaults.standard.synchronize()
                    
                    //save lockid to user standards, from the authenticate method 
                    if resString["LockID"].stringValue == ""
                    {
                        //make set lockID pop up
                           UserDefaults.standard.set(false, forKey: "LockIDPresent")
                           UserDefaults.standard.synchronize()
                    }
                    else {
                        //stop set lockID from popping up and store the LockID for future use
                        let id = resString["LockID"].stringValue
                        UserDefaults.standard.set(true, forKey: "LockIDPresent")
                        UserDefaults.standard.set(id, forKey: "LockID")
                        UserDefaults.standard.synchronize()
                    }
                    
                    //test token save to user standards
                 //   print(UserDefaults.standard.value(forKey: "token") ??  "no token stored")
                    
                    //move to next window here
                    UserDefaults.standard.set(true,forKey:"isUserLoggedIn");
                    UserDefaults.standard.synchronize();
                    self.dismiss(animated: true, completion: nil);

                    
                }
                else if resString["success"].stringValue == "false"
                {
                    //pop up a box saying incorrect user please try again
                     print(resString["message"].stringValue);
                    UserDefaults.standard.set(resString["message"].stringValue,forKey:"loginFailed");
                    //this doesnt work - fix it
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage("Your credentials are incorrect. Please check your email and password.")
                    }
                    
                    
                }

                //   print(resString["success"].stringValue)
                //   print(resString["token"].stringValue)
                
            }
            
        }
        task.resume()
    }

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    
    @IBAction func login(_ sender: Any) {
        
        let userPassword = password.text
        let userEmail = email.text
        
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)!)
        {
            // Display alert message
            
            displayMyAlertMessage("All fields are required");
            
            return;
        }
        
        login()
        
    }
    
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }

}
