//
//  ViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 14/12/2016.
//  Copyright © 2016 Nikhil Vedi. All rights reserved.
//

//to post to an /unLock it must be put in the URL

import UIKit

class ViewController: UIViewController {
   
    
    
    func presentAlert() {
        let alertController = UIAlertController(title: "IP?", message: "Please input your unique key:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                //this could be lock unique key name etc in future
                UserDefaults.standard.set(field.text, forKey: "userIP")
                UserDefaults.standard.synchronize()
            } else {
                // user did not fill field - doesnt currently work
                print("no input given")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
    
        alertController.addTextField { (textField) in
            textField.placeholder = "IP"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    func un_lock()
    {
        let u = UserDefaults.standard.value(forKey: "userIP")!
        let url_to_unlock:String = "http://\(u):3000/unLock"
        print(url_to_unlock)
        let url:URL = URL(string: url_to_unlock)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //make this work
        let paramString = "data=unLocking at \(Timestamp)"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("Error comunicating with server, Check IP")
                return
            }
            //for errors
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString! )
            
        })
        
        task.resume()
    }
    
    func lock()
    {
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        let url_to_lock:String = "http://\(u):3000/Lock"
        
        let url:URL = URL(string: url_to_lock)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //make this work
        let paramString = "data=Locking at \(Timestamp)"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("Error comunicating with server, Check IP")
                return
            }
            //for errors
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString! )
            
        })
        
        task.resume()
        
    }
    
    func login()
    {
        let u = UserDefaults.standard.value(forKey: "userIP")!
     //   let url_to_login = "http://\(u):3000/users/authenticate"
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
           //print("responseString = \(responseString)")
            UserDefaults.standard.set((responseString), forKey: "token")
            UserDefaults.standard.synchronize()
        }
        task.resume()
        

        print(UserDefaults.standard.value(forKey: "token") ?? "nill")

    }

    @IBAction func ip(_ sender: UIButton) {
     presentAlert()
    }
   
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
   
    
    //button actions 
    
    @IBAction func Submit(_ sender: UIButton) {
       
        login()
    }

    @IBAction func lock(_ sender: UIButton) {
        lock()
    }
    
    @IBAction func unLock(_ sender: Any) {
        un_lock()

    }
      }

