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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login()
    {
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
            // print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    
                    //save token to user standards
                    
                    UserDefaults.standard.set((resString["token"].stringValue), forKey: "token")
                    UserDefaults.standard.synchronize()
                    
                    //test save to user standards
                    print(UserDefaults.standard.value(forKey: "token") ??  "no token stored")
                    //move to next window here
                    UserDefaults.standard.set(true,forKey:"isUserLoggedIn");
                    UserDefaults.standard.synchronize();
                    self.dismiss(animated: true, completion: nil);

                    
                }
                else if resString["success"].stringValue == "false"
                {
                    //pop up a box saying incorrect user please try again
                     print(resString["message"].stringValue);
                    
//                    let alertController = UIAlertController(title: "Error", message: "Incorrect Details", preferredStyle: .alert)
//                  
//                    
//                    alertController.addTextField { (textField) in
//                        textField.placeholder = "IP"
//                    }
//                     let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
//                    
//                    alertController.addAction(okAction)
//                    
//                    self.present(alertController, animated: true, completion: nil)
                    
                    

                    
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
        
        login()
        
    }
}
