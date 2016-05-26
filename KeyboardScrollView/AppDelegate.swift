//
//  AppDelegate.swift
//  keyboardScroll
//
//  Created by Ethan Neff on 5/26/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    navigateToFirstController()
    return true
  }
  
  func navigateToFirstController() {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    if let window = window {
      window.backgroundColor = UIColor.whiteColor()
      window.rootViewController = ViewController()
      window.makeKeyAndVisible()
    }
  }
}

