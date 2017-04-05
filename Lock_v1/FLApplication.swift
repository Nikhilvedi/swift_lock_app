//
//  FLApplication.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 03/02/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import UIKit
import Foundation

class FLApplication: UIApplication
{
    override func sendEvent(_ event: (UIEvent!))
    {
        super.sendEvent(event)
        print("send event") // this is an example
        // ... dispatch the message...
    }
}
