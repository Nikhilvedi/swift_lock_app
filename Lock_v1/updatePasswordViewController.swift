//
//  updatePasswordViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 02/04/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftyJSON
import Navajo_Swift

class updatePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Do any additional setup after loading the view.
    }
    /**
     Manage the password strength checking using Navajo
     */
    @IBAction func passwordChanged(_ sender: Any) {
        let password1 = self.password1.text
        let strength = Navajo.strength(of: password1!)
        strengthLabel.text = Navajo.localizedString(for: strength)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///referencing outlets
    @IBOutlet weak var password1: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    
    /**
     Back button handling
     */
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }

    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var password2: HoshiTextField!
    
    /**
     Submit button, calling change password method after checking they're the same
     */
    @IBAction func submit(_ sender: Any) {
        
        let password1 = self.password1.text
        let password2 = self.password2.text
        
        if(password1 != password2)
        {
            // Display an alert message
            displayMyAlertMessage("Passwords do not match");
            return;
        }
        else {
         changePassword()   
        }
        
    }
    
    /**
     Handle the change password POST method
     */
    func changePassword()
    {
         let email = self.email.text
        let password1 = self.password1.text
        
        if (UserDefaults.standard.value(forKey: "userIP") == nil)
        {
            UserDefaults.standard.set("localhost", forKey: "userIP")
            
            print("Local host programatically set");
        }
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/users/update")!)
        request.httpMethod = "POST"
        let postString = "name=\(email!)&password=\(password1!)"
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
                      ///close the  registration page and prompt for login if successful response from server
                    DispatchQueue.main.async() {
                         self.displayMyAlertMessage(resString["message"].stringValue)
                      
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    ///error handling for already signed up users
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
            }
            
        }
        task.resume()
        
        ///set the text boxes to empty when complete 
        self.password1.text = ""
        self.password2.text = ""
        self.email.text = ""
        
    }
    /**
    Display a message with a messagebox
     */
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    
}
