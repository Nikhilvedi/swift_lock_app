//
//  ViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 14/12/2016.
//  Copyright © 2016 Nikhil Vedi. All rights reserved.
//

//to post to an /unLock it must be put in the URL

import UIKit
import SwiftyJSON


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add if nil bit for this as it breaks on fresh install 
        // set welcome text for label 
          if UserDefaults.standard.object(forKey: "email") != nil{
            let e = UserDefaults.standard.value(forKey: "email")!
            welcome.text = "Welcome to Cloud Locks, \(e)"
        }
          else {
            welcome.text = "Welcome to Cloud Locks"
        }
       
    }
    
    //check token after 3 minutes - should have expired, work on kicking user out
    func tokenCheck()
    {
    DispatchQueue.main.asyncAfter(deadline: .now() + 60) {      //check after 60 seconds
        var e = "noemail"
        var t = "notoken"
        
        let u =  UserDefaults.standard.value(forKey: "userIP")!
        if (UserDefaults.standard.value(forKey: "email") != nil)
        {
         e = UserDefaults.standard.value(forKey: "email")! as! String
        }
        if (UserDefaults.standard.value(forKey: "token") != nil)
        {
         t = UserDefaults.standard.value(forKey: "token")! as! String
        }
        
        print(t)        //this prints the stored token
        
        let urlPath = "http://\(u):3000/users/tokencheck"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET" // make it post if you want
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//This is just an example, put the Content-Type that suites you
        request.addValue(e , forHTTPHeaderField: "name")
        request.addValue(t , forHTTPHeaderField: "x-access-token")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("error=\(error)")
            
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    print("success")
                }
                else if resString["success"].stringValue == "false"
                {
                    print(resString["message"].stringValue)
                    //logout
                   // UserDefaults.standard.set(false ,forKey: "isUserLoggedIn");
                  // self.performSegue(withIdentifier: "LoginView", sender: self)
                    self.displayMyAlertMessage("You have been logged off for your sequrity")
                   self.logout()
                
                }
            }
        })
        
        task.resume()
 
    }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        let doesUserHaveLock = UserDefaults.standard.bool(forKey: "LockIDPresent");
        
       
         if(!isUserLoggedIn) {
            self.performSegue(withIdentifier: "LoginView", sender: self)
            //testing
           // print(doesUserHaveLock)
        }
        
         else  if (isUserLoggedIn) && (!doesUserHaveLock)
         {
            self.performSegue(withIdentifier: "Setup", sender: self)
        }
           //print(doesUserHaveLock)
        if (isUserLoggedIn == true)
        {
         tokenCheck()
        }
      }
   
    
    func un_lock()
    {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        //make post strings send back the users email, LockID?
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        let url_to_unlock:String = "http://\(u):3000/unLock"
        let n = UserDefaults.standard.value(forKey: "email")!
        let l = UserDefaults.standard.value(forKey: "LockID")!
       
        let postString = "name=\(n)&LockID=\(l)"
            var request = URLRequest(url: URL(string: url_to_unlock)!)

        //testing
      //  print(postString)
      //  print(url_to_unlock)
        request.httpMethod = "POST"
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
                   //handle success
                    //animate a lock shutting maybe?
                    //print for now
                    print(resString["message"].stringValue)
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    //error handling for failed unlock
                   // print(resString["message"].stringValue)
                    
                    //hop back onto main stack to pop up message box
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                    }
                }
            }
                 task.resume()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        
        //make this work for the activity spinner in top bar
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        }
    
    
    func lock()
    {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        let u = UserDefaults.standard.value(forKey: "userIP")!
        let url_to_lock:String = "http://\(u):3000/Lock"
        let n = UserDefaults.standard.value(forKey: "email")!
        let l = UserDefaults.standard.value(forKey: "LockID")!
        
        let postString = "name=\(n)&LockID=\(l)"
        var request = URLRequest(url: URL(string: url_to_lock)!)
        
        //testing
        //  print(postString)
        //  print(url_to_unlock)
        request.httpMethod = "POST"
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
                    //handle success
                    //animate a lock shutting maybe?
                    //print for now
                    print(resString["message"].stringValue)
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    //error handling for failed unlock
                    // print(resString["message"].stringValue)
                    
                    //hop back onto main stack to pop up message box
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                      UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                }
            }
        }
        task.resume()
        
        
        //make this work for the activity spinner in top bar
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
    }
    
    func logout(){
        
        //set user to logged out
        UserDefaults.standard.set(false,forKey:"isUserLoggedIn");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "LoginView", sender: self);
        
        //remove/destroy token
        if Bundle.main.bundleIdentifier != nil {
            UserDefaults.standard.removePersistentDomain(forName: "token")
        }

    }
    
    @IBAction func logoutbutton(_ sender: Any) {
        logout()
    }
    
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    @IBOutlet weak var activityForLOck: UIActivityIndicatorView!

    @IBOutlet weak var welcome: UILabel!
    
    //button actions

    //fix this label thing

    @IBAction func lock(_ sender: UIButton) {
        lock()
    }
    
    @IBAction func unLock(_ sender: Any) {
        un_lock()

    }
    
    
      }

