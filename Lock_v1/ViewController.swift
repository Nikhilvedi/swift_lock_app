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

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            self.performSegue(withIdentifier: "LoginView", sender: self)
        }
        
        
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
   

    @IBAction func logoutbutton(_ sender: Any) {
        UserDefaults.standard.set(false,forKey:"isUserLoggedIn");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "LoginView", sender: self);

    }
    
    //button actions 


    @IBAction func lock(_ sender: UIButton) {
        lock()
    }
    
    @IBAction func unLock(_ sender: Any) {
        un_lock()

    }
      }

