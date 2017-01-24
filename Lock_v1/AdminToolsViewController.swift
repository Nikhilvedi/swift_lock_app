//
//  AdminToolsViewController.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 24/01/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit

class AdminToolsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    

    @IBAction func InputIP(_ sender: Any) {
        presentAlert()
    }
    
    
    @IBAction func back(_ sender: Any) {
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
