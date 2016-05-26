//
//  ViewController.swift
//  keyboardScroll
//
//  Created by Ethan Neff on 5/26/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  // MARK: properties
  let textFieldPadding: CGFloat = 20
  let textFieldHeight: CGFloat = 40
  let scrollView: UIScrollView = UIScrollView()
  var scrollViewContentHeight: CGFloat = 0
  var scrollViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
  
  // MARK: init
  override func loadView() {
    super.loadView()
    createView()
    createListeners()
  }
  
  private func createListeners() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
    view.addGestureRecognizer(tap)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  private func createView() {
    view.backgroundColor = UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    scrollView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    scrollView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    scrollViewBottomConstraint = scrollView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
    scrollViewBottomConstraint.active = true
    
    var prev: UITextField = UITextField()
    for i in 0..<20 {
      if i == 0 {
        prev = createTextField(scrollView.topAnchor, placeholder: i)
      } else {
        let next = createTextField(prev.bottomAnchor, placeholder: i)
        prev = next
      }
    }
    scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewContentHeight + textFieldPadding)
  }
  
  private func createTextField(topAnchor: NSLayoutYAxisAnchor, placeholder: Int) -> UITextField {
    let textField = UITextField()
    scrollView.addSubview(textField)
    textField.placeholder = "textfield \(placeholder+1)"
    textField.borderStyle = .RoundedRect
    textField.returnKeyType = .Next
    textField.backgroundColor = .whiteColor()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.topAnchor.constraintEqualToAnchor(topAnchor, constant: textFieldPadding).active = true
    textField.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: textFieldPadding).active = true
    textField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -textFieldPadding).active = true
    textField.heightAnchor.constraintEqualToConstant(textFieldHeight
      ).active = true
    scrollViewContentHeight += textFieldHeight + textFieldPadding
    
    return textField
  }
  
  // MARK: deinit
  deinit {
    dealloc()
  }
  
  private func dealloc() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  // MARK: keyboard
  func dismissKeyboard(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
      let endFrameHeight: CGFloat = endFrame?.size.height ?? 0.0
      let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
      let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
      if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
        scrollViewBottomConstraint.constant = 0.0
      } else {
        scrollViewBottomConstraint.constant = -endFrameHeight
      }
      UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: animationCurve, animations: {
        self.view.layoutIfNeeded()
        }, completion: nil)
    }
  }
}

