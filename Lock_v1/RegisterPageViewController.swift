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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var LockID: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        
        let userEmail = email.text
        let userPassword = password.text
        let userPasswordConfirm = password2.text
        
        //validation before sending to server 
        
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userPasswordConfirm?.isEmpty)!)
        {
            
            // Display alert message
            
            displayMyAlertMessage("All fields are required");
            
            return;
        }
        
        //Check if passwords match
        if(userPassword != userPasswordConfirm)
        {
            // Display an alert message
            displayMyAlertMessage("Passwords do not match");
            return;
            
        }
        
        register()

        email.text = "";
        password.text="";
        password2.text="";
        LockID.text="";
    }
    
    func register()
    {
        //store everything in user defaults
        
        UserDefaults.standard.set(email.text!, forKey: "email")
        UserDefaults.standard.set(password.text!, forKey: "password")
        UserDefaults.standard.synchronize()
        
        if (LockID.text?.isEmpty)!
        {
            print("no lockID")
              UserDefaults.standard.set(false, forKey: "LockIDPresent")
              UserDefaults.standard.synchronize()
            
        }
        else
        {
            print(LockID.text as Any)
             UserDefaults.standard.set(LockID.text!, forKey: "LockID")
                UserDefaults.standard.set(true, forKey: "LockIDPresent")
               UserDefaults.standard.synchronize()
        }
        
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/users")!)
        request.httpMethod = "POST"
        let postString = "name=\(email.text!)&password=\(password.text!)&LockID=\(LockID.text!)"
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
             print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    DispatchQueue.main.async() {
                    self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    //error handling for already signed up users

                    print(resString["message"].stringValue);
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
    
    @IBAction func HaveAccount(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

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
