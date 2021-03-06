//
//  ViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 14/12/2016.
//  Copyright © 2016 Nikhil Vedi. All rights reserved.
//


import UIKit
import SwiftyJSON



extension UIViewController {
    /**
     Hides the keyboard when anywhere in the view controller is clicked
     */
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
        /// set welcome text for label
            UserDefaults.standard.synchronize();
        
          if UserDefaults.standard.object(forKey: "email") != nil{
            welcome.text = "Welcome to Cloud Locks"
        }
          else {
            welcome.text = "Welcome to Cloud Locks"
        }
       
    }
    
    /**
     Check token after 2 minutes - should have expired, kick user out
     */
    func tokenCheck()
    {
         /// viewController is visible
        if ((self.isViewLoaded) && (self.view.window != nil)) {
            ///check after 180 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 120) {

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
        
        print(t)        ///this prints the stored token
        
        let urlPath = "http://\(u):3000/users/tokencheck"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(e , forHTTPHeaderField: "name")
        request.addValue(t , forHTTPHeaderField: "x-access-token")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("error=\(error)")
            
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {                /// check for http errors
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
                    UserDefaults.standard.set(false,forKey:"isUserLoggedIn");
                    UserDefaults.standard.synchronize();
                      self.displayMyAlertMessageLoginView("You have been logged off due to security settings")
                
                }
            }
        })
        
        task.resume()
    }
    }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        let doesUserHaveLock = UserDefaults.standard.bool(forKey: "LockIDPresent");
        print(isUserLoggedIn)
       
         if(!isUserLoggedIn) {
            self.performSegue(withIdentifier: "LoginView", sender: self)

        }
        
         else  if (isUserLoggedIn) && (!doesUserHaveLock)
         {
            self.performSegue(withIdentifier: "Setup", sender: self)
        }
        
         tokenCheck()
      
      }
   
    /**
     * Handle the POST for the unlock to the RESTful API
     */
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
                    //print and message box
                    print(resString["message"].stringValue)
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                         self.lockStatusText.font = UIFont.boldSystemFont(ofSize: 17.0)
                        
                        self.lockStatusText.text = "UNLOCKED"
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    //error handling for failed unlock
                    //hop back onto main queue to pop up message box
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                    }
                }
            }
                 task.resume()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        
        }
    
    
    /**
     * Handle the POST for the lock to the RESTful API
     */
    func lock()
    {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        let u = UserDefaults.standard.value(forKey: "userIP")!
        let url_to_lock:String = "http://\(u):3000/Lock"
        let n = UserDefaults.standard.value(forKey: "email")!
        let l = UserDefaults.standard.value(forKey: "LockID")!
        
        let postString = "name=\(n)&LockID=\(l)"
        var request = URLRequest(url: URL(string: url_to_lock)!)
        
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
                    //print and message box
                    print(resString["message"].stringValue)
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                          self.lockStatusText.font = UIFont.boldSystemFont(ofSize: 17.0)
                            self.lockStatusText.text = "LOCKED"
                    }
                }
                else if resString["success"].stringValue == "false"
                {
                    //error handling for failed unlock
                    //hop back onto main queue to pop up message box
                    DispatchQueue.main.async() {
                        self.displayMyAlertMessage(resString["message"].stringValue)
                    }
                      UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                }
            }
        }
        task.resume()
        
        
    }
    
    /**
     * Log out method and destroy token
     */
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
    
    /**
     * Button event for logout
     */
    @IBAction func logoutbutton(_ sender: Any) {
        logout()
    }
    
    /**
     * Displaying an alert message
     */
    func displayMyAlertMessage(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
   
    /**
     * Displaying an alert message for being kicked out of the system due to token expiry
     */
    func displayMyAlertMessageLoginView(_ userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Message", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
       
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:  { action in self.performSegue(withIdentifier: "LoginView", sender: self) })
        
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    
    @IBOutlet weak var activityForLOck: UIActivityIndicatorView!

    @IBOutlet weak var welcome: UILabel!
    

    /**
     * Lock button action
     */
    @IBAction func lock(_ sender: UIButton) {
        lock()
    }
    
    @IBOutlet weak var lockStatusText: UILabel!
    /**
     * Unlock button action
     */
    @IBAction func unLock(_ sender: Any) {
        un_lock()

    }
    
      }

