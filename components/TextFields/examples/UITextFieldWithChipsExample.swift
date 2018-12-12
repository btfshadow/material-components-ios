// Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

/*
 todo:
  * RTL Support
 */

class UITextFieldWithChipsExample: UIViewController {

  let textField = InsetTextField()
  var leftView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.white

    setupExample()
  }

  func setupExample() {

    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = UIColor.orange.withAlphaComponent(0.05)
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.orange.cgColor
    textField.textColor = .orange
    textField.text = "Hit Enter Here"

    textField.delegate = self

    view.addSubview(textField)

    // position the textfield somewhere in the screen
    if #available(iOSApplicationExtension 11.0, *) {
      let guide = view.safeAreaLayoutGuide
      textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20.0).isActive = true
      textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -60.0).isActive = true
      textField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 40.0).isActive = true
    } else if #available(iOSApplicationExtension 9.0, *) {
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
      textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
    } else {
      // Fallback on earlier versions
      print("This example is supported on iOS version 9 or later.")
    }

    leftView.translatesAutoresizingMaskIntoConstraints = false
    leftView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)

    textField.leftView = leftView
    textField.leftViewMode = .always
  }

  func appendLabel(text: String) {

    let pad: CGFloat = 5.0

    // create label and add to left view
    let label = newLabel(text: text)
    let lastLabel = leftView.subviews.last
    leftView.addSubview(label)

    // add constraints
    var lastmax: CGFloat = 0
    if #available(iOSApplicationExtension 9.0, *) {
      label.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
      label.bottomAnchor.constraint(equalTo: leftView.bottomAnchor).isActive = true
      if let lastLabel = lastLabel {
        label.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: pad).isActive = true
        lastmax = lastLabel.frame.maxX
      } else {
        label.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: pad).isActive = true
      }
    } else {
      // Fallback on earlier versions
      print("This example is supported on iOS version 9 or later.")
    }

    // adjust text field's inset and width
    label.layoutIfNeeded()
    label.frame.origin.x = lastmax
    textField.insetX = label.frame.maxX + 10
  }

  func newLabel(text: String) -> UILabel {
    // create label and add to left view
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = UIColor.red.withAlphaComponent(0.4)
    label.text = " " + text + " "
    label.textColor = .white
    label.layer.cornerRadius = 3.0
    label.layer.masksToBounds = true
    return label
  }
}

// MARK: Example Extensions

extension UITextFieldWithChipsExample: UITextFieldDelegate {

  // listen to "enter" key
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string == "\n" {
      if let text = textField.text {
        appendLabel(text: text)
        textField.text = ""
      }
    }
    return true
  }
}

extension UITextFieldWithChipsExample {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

extension UITextFieldWithChipsExample {

  class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["Action Sheet", "A UI Text Fields With (Simulated) Chips"],
      //"breadcrumbs": ["Text Field", "UI Text Fields With (Simulated) Chips"],
      "primaryDemo": false,
      "presentable": false,
    ]
  }
}

// MARK: UITextField Subclass

class InsetTextField: UITextField {

  // x position where chips view ends and text begins. Updating this property moves the
  // position of chips & text.
  var insetX: CGFloat = 5.0 //{
  //    didSet {
  //      layoutIfNeeded()    // this might still be needed...
  //    }
  //  }
  //  var insetY: CGFloat = 0 {
  //    didSet {
  //      layoutIfNeeded()
  //    }
  //  }
  // default padding for the textfield, taking insetX into account for the left position
  var insetRect: UIEdgeInsets { return UIEdgeInsets(top: 5.0, left: insetX, bottom: 5.0, right: 5.0) }

  // text bounds
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let superbounds = super.textRect(forBounds: bounds)
//    let newbounds = UIEdgeInsetsInsetRect(superbounds, insetRect)
    var newbounds = superbounds
    newbounds.origin.x = insetX
    return newbounds
  }

  // text bounds while editing
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let superbounds = super.editingRect(forBounds: bounds)
//    let newbounds = UIEdgeInsetsInsetRect(superbounds, insetRect)
    var newbounds = superbounds
    newbounds.origin.x = insetX
    // print("-> insetX: \(insetX) - editingRect(forBounds: \(bounds) | superbounds: \(superbounds) | change to: \(newbounds)")
    return newbounds
  }

  // left view bounds
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    let superbounds = super.leftViewRect(forBounds: bounds)
//    var newbounds = UIEdgeInsetsInsetRect(superbounds, UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
//    newbounds.size.width = insetX - 10.0
    var newbounds = superbounds
    newbounds.size.width = insetX - 10
    return newbounds
  }
}