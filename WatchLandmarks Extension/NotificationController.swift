//
//  NotificationController.swift
//  WatchLandmarks Extension
//
//  Created by Philipp on 08.11.19.
//  Copyright © 2019 Philipp. All rights reserved.
//

import WatchKit
import SwiftUI
import UserNotifications
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let notification = OSLog(subsystem: subsystem, category: "notification")
}

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var landmark: Landmark?
    var title: String?
    var message: String?
        
    let landmarkIndexKey = "landmarkIndex"

    override var body: NotificationView {
        os_log("NotificationController: body called (title=%{PUBLIC}@)", log: OSLog.notification, type: .info, title ?? "n/a")
        return NotificationView(title: title,
            message: message,
            landmark: landmark)
    }

    override func willActivate() {
        os_log("NotificationController: willActivate called (title=%{PUBLIC}@)", log: OSLog.notification, type: .info, title ?? "n/a")
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        os_log("NotificationController: didDeactivate called (title=%{PUBLIC}@)", log: OSLog.notification, type: .info, title ?? "n/a")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /// ---- Bug in watchOS? didReceive is never called!
    override func didReceive(_ notification: UNNotification) {
        os_log("NotificationController: didReceive called (notification=%{PUBLIC}@)", log: OSLog.notification, type: .info, notification)
        let userData = UserData()
        
        let notificationData =
            notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        message = alert?["body"] as? String
        
//        print("title: \(title)")
//        print("message: \(message)")

        if let index = notificationData?[landmarkIndexKey] as? Int {
            landmark = userData.landmarks[index]
        }
    }

    /// ---- This variation of didReceive (marked as deprecated) is getting called!?
    /// But nevertheless the UI is not shown
//    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
//        os_log("NotificationController: didReceive withCompletion called (notification=%{PUBLIC}@)", log: OSLog.notification, type: .info, notification)
//        let userData = UserData()
//
//        let notificationData =
//            notification.request.content.userInfo as? [String: Any]
//
//        let aps = notificationData?["aps"] as? [String: Any]
//        let alert = aps?["alert"] as? [String: Any]
//
//        title = alert?["title"] as? String
//        message = alert?["body"] as? String
//
//        if let index = notificationData?[landmarkIndexKey] as? Int {
//            landmark = userData.landmarks[index]
//        }
//
//        print("title: \(title)")
//        print("message: \(message)")
//        print("landmark: \(landmark)")
//
//        didReceive(notification)
//        completionHandler(.custom)
//
//    }
}
