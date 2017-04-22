//
//  RegisterPageViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 22/01/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when anywhere tapped
         self.hideKeyboardWhenTappedAround()
        name.borderStyle = UITextBorderStyle.none;
        email.borderStyle = UITextBorderStyle.none;
        password.borderStyle = UITextBorderStyle.none;
        password2.borderStyle = UITextBorderStyle.none;
        LockID.borderStyle = UITextBorderStyle.none;
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var LockID: UITextField!
    
    
    /**
     Handle the register button command and check if the fields are populuated
     */
    @IBAction func registerButton(_ sender: Any) {
        
        let userName = name.text
        let userEmail = email.text
        let userPassword = password.text
        let userPasswordConfirm = password2.text
        
        ///validation before sending to API
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userPasswordConfirm?.isEmpty)! || (userName?.isEmpty)!)
        {
            /// Display alert message
            displayMyAlertMessage("All fields are required");
            return;
        }
            ///Check if passwords match
        if(userPassword != userPasswordConfirm)
        {
            /// Display an alert message
            displayMyAlertMessage("Passwords do not match");
            return;
            
        }
            ///validate email
       if (isValidEmail(testStr: userEmail!) == true)
       {
            /// call the register method
            register()
        }
        else
       {
        displayMyAlertMessage("Please enter a valid email address")
        }
    }
    /**
     Handle the email validation
     */
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /**
     Handle the register command and POST the information to the RESTful API
     */
    func register()
    {
        //store everything in user defaults
        
        UserDefaults.standard.set(name.text!, forKey: "name")
        UserDefaults.standard.set(email.text!, forKey: "email")
        UserDefaults.standard.set(password.text!, forKey: "password")
        UserDefaults.standard.synchronize()
        
        if (LockID.text?.isEmpty)!
        {
            print("no lockID")
            
              UserDefaults.standard.set(false, forKey: "LockIDPresent")
              UserDefaults.standard.synchronize()
         ///   sets and sends lockID as an empty string so the field is initialised
            LockID.text = nil;
        }
        else
        {
            print(LockID.text as Any)
             UserDefaults.standard.set(LockID.text!, forKey: "LockID")
                UserDefaults.standard.set(true, forKey: "LockIDPresent")
               UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.value(forKey: "userIP") == nil)
        {
            UserDefaults.standard.set("localhost", forKey: "userIP")
            
            print("Local host programatically set");
        }
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/users")!)
        request.httpMethod = "POST"
        let postString = "name=\(email.text!)&password=\(password.text!)&LockID=\(LockID.text!)&firstname=\(name.text!)"
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
             print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    ///success
                    DispatchQueue.main.async() {
                        self.dismiss(animated: true, completion: nil)
                                          }
                                  }
                else if resString["success"].stringValue == "false"
                {
                    ///error handling for already signed up users
                    print(resString["message"].stringValue);
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
            }
            
        }
        task.resume()
        ///set fields to empty
        email.text = "";
        password.text="";
        password2.text="";
        LockID.text="";
        name.text="";
    }
    
    /**
     Display a message via an alert
     */
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    /**
     Handle the have account button (back) 
     */
    @IBAction func HaveAccount(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
 

}
