//
//  PasswordlessVerifyController.swift
//  Auth0Sample
//
//  Created by Vikas Kannurpatti Jayaram on 7/3/19.
//  Copyright © 2019 Auth0. All rights reserved.
//

import UIKit
import Auth0

class PasswordlessVerifyController: UIViewController, UITextFieldDelegate {
    var phoneNumber: String?
    var otp: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /* Below method is inherited from UITextFieldDelegate, it will be invoked when text filed get focus and click return key. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        NSLog("TextField textFieldShouldReturn method triggered.")
        NSLog("TextField TextField method triggered and the input text is '\n'. \(textField.text)")
        self.otp = textField.text;
        return true
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
    
    @IBAction func verifyOtp(_ sender: UIButton) {
        print("Verify OTP")
        print(self.phoneNumber)
        print(self.otp)

        if (self.otp != nil) {
            self.verifyOtpPhone(phoneNumber: self.phoneNumber!, otp: self.otp!);
        }
        
    }
    
    
    func verifyOtpPhone(phoneNumber: String, otp: String) {
        let paramString = "\(phoneNumber)"
        let escaped = paramString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        print("escaped: \(escaped)")

        Auth0
            .webAuth()
            .logging(enabled: true)
            .connection("sms")
            .parameters([
                "scope": "openid offline_access",
                "phone_number": phoneNumber,
                "verification_code": otp])
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Success Verfiry Otp Phone : \(credentials)")
                case .failure(let error):
                    print("Error Verfiry Otp Phone \(error)")
                }
        }
    }
}

