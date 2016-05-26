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
    scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0),
      scrollViewBottomConstraint,
      ])
    
    var prev: UITextField = UITextField()
    for i in 0..<20 {
      if i == 0 {
        prev = createTextField(item: scrollView, attribute: .Top, placeholder: i)
      } else {
        let next = createTextField(item: prev, attribute: .Bottom, placeholder: i)
        prev = next
      }
    }
    scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewContentHeight + textFieldPadding)
  }
  
  private func createTextField(item item: AnyObject, attribute: NSLayoutAttribute, placeholder: Int) -> UITextField {
    let textField = UITextField()
    scrollView.addSubview(textField)
    textField.placeholder = "textfield \(placeholder+1)"
    textField.borderStyle = .RoundedRect
    textField.backgroundColor = .whiteColor()
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: item, attribute: attribute, multiplier: 1, constant: textFieldPadding),
      NSLayoutConstraint(item: textField, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: textFieldPadding),
      NSLayoutConstraint(item: textField, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -textFieldPadding),
      NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: textFieldHeight),
      ])
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

