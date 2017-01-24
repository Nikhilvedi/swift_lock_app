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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBOutlet weak var LockID: UITextField!
    
    @IBAction func setup(_ sender: Any) {
        
        
        let u = UserDefaults.standard.value(forKey: "userIP")!
        var request = URLRequest(url: URL(string: "http://\(u):3000/users/returnLockID")!)
        request.httpMethod = "PUT"
        let postString = "LockID=\(LockID.text!)"
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
            // print("responseString = \(responseString)")
            
            if let data = responseString?.data(using: String.Encoding.utf8) {
                let resString = JSON(data: data)
                
                if resString["success"].stringValue == "true"
                {
                    print("works");
                    
                }
                else if resString["success"].stringValue == "false"
                {
                    print("failed")
                    print(resString["false"].stringValue)
                }
                
            }
        }
    task.resume()
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
