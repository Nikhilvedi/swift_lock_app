//
//  TimerUIApplication.swift
//  Lock_v1
//
//  Created by Nikhil vedi on 03/02/2017.
//  Copyright © 2017 Nikhil Vedi. All rights reserved.
//

import Foundation

class TimerUIApplication: UIApplication {
    
    static let ApplicationDidTimoutNotification = "AppTimout"
    
    // The timeout in seconds for when to fire the idle timer.
    let timeoutInSeconds: TimeInterval = 5 * 60
    
    var idleTimer: Timer?
    
    // Listen for any touch. If the screen receives a touch, the timer is reset.
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches() {
            for touch in touches {
                if touch.phase == UITouchPhase.Began {
                    self.resetIdleTimer()
                }
            }
        }
    }
    
    // Resent the timer because there was user interaction.
    func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(TimerUIApplication.idleTimerExceeded), userInfo: nil, repeats: false)
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TimerUIApplication.ApplicationDidTimoutNotification), object: nil)
    }
}
