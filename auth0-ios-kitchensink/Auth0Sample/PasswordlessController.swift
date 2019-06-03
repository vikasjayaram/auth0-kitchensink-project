//
//  PasswordlessController.swift
//  Auth0Sample
//
//  Created by Vikas Kannurpatti Jayaram on 7/3/19.
//  Copyright © 2019 Auth0. All rights reserved.
//

import UIKit
import Auth0

class PasswordlessController: UIViewController, UITextFieldDelegate {
    
    var phoneNumber: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    /* Below method is inherited from UITextFieldDelegate, it will be invoked when text filed get focus and click return key. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        NSLog("TextField textFieldShouldReturn method triggered.")
        NSLog("TextField TextField method triggered and the input text is '\n'. \(textField.text)")
        self.phoneNumber = textField.text;
        return true
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
    }
    /* Invoked when first edit the textfield control. */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        NSLog("TextField textFieldDidBeginEditing method triggered.")
        
        // Clear the default text.
        
        textField.placeholder = nil
        
    }
    
    /* Invoked when first edit the textview control. */
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        NSLog("TextView textViewDidBeginEditing method triggered.")
        
        // Clear the default text.
        textView.text = nil
        
    }
    
    @IBAction func sendOtp(_ sender: UIButton) {
        print("Sending OTP \(self.phoneNumber)")
        if (self.phoneNumber != nil) {
            //self.showVerifyScreen();
            self.sendPhoneOtp(phoneNumber: self.phoneNumber!);
            self.showVerifyScreen();
        } else {
            print("No phonenumber")
        }
        
    }
    
    func sendPhoneOtp(phoneNumber: String) {
        Auth0
            .authentication()
            .logging(enabled: true)
            .startPasswordless(phoneNumber: phoneNumber, type: .Code, connection: "sms")
            .start { result in
                switch result {
                case .success:
                    print("Success Otp Phone")
                case .failure(let error):
                    print("Error OTP Phone : \(error)")
                }
        }
        
    }
    
    
    func showVerifyScreen () {
        let controller =  self.storyboard?.instantiateViewController(withIdentifier: "PasswordlessVerifyController") as! PasswordlessVerifyController
        controller.phoneNumber = self.phoneNumber;
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
