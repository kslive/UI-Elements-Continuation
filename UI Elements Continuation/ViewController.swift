//
//  ViewController.swift
//  UI Elements Continuation
//
//  Created by Eugene Kiselev on 11.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        textView.text = ""
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Light", size: 17)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(updateTextView(notification:)),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)

        NotificationCenter.default.addObserver(self,
                                       selector: #selector(updateTextView(notification:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyBoardFrame.height - bottomConstraint.constant ,
                                                 right: 0)
            
            textView.scrollRangeToVisible(textView.selectedRange)
        }
        
    }

}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .darkGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}

