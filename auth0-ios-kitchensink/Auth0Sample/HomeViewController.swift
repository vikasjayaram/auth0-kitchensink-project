// HomeViewController.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Auth0
import Lock

class HomeViewController: UIViewController {

    // MARK: - IBAction
    @IBAction func showLoginController(_ sender: UIButton) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .logging(enabled: true)
            .connection("Username-Password-Authentication")
            .scope("openid profile")
            .audience("https://" + clientInfo.domain + "/userinfo")
            .parameters([
                "username": "vikas+1000@auth0.com",
                "password" : "Marvin!1"
            ])
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken else { return }
                    self.showSuccessAlert(accessToken)
                }
        }
    }
    
    @IBAction func showLoginLockController(_ sender:UIButton) {
        Lock
            .classic()
            // withConnections, withOptions, withStyle, and so on
            .withOptions {
                $0.oidcConformant = false
                $0.scope = "openid profile"
                $0.mustAcceptTerms = true
                $0.logLevel = .all
                $0.logHttpRequest = true
            }
            .onAuth { credentials in
                // Let's save our credentials.accessToken value
                guard let accessToken = credentials.accessToken else { return }
                self.userinfo(accessToken)
            }
            .present(from: self)
    }

    // MARK: - Private
    fileprivate func showSuccessAlert(_ accessToken: String) {
        let alert = UIAlertController(title: "Success", message: "accessToken: \(accessToken)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK Now Logout", style: .default, handler: logoutHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logoutHandler (alert: UIAlertAction!) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
//        Auth0
//            .webAuth(clientId: clientInfo.clientId, domain: clientInfo.domain)
//            .clearSession(federated: true) {print($0)}
 
        Auth0
            .webAuth()
            .clearSession(federated: true) { [weak self](sucess) in
                if sucess {
                    print(sucess);
                }
        }

    }
    
    func userinfo (_ accessToken: String) {
        Auth0
            .authentication()
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch result {
                case .success(let profile):
                    print("User Profile: \(profile)")
                case .failure(let error):
                    print("Failed with \(error)")
                }
        }
    }

}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }

    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}
