//
//  FirebaseAuthViewController.swift
//  WeatherReporter
//
//  Created by (s) Toby Bessant on 21/03/2018.
//  Copyright © 2018 (s) Toby Bessant. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class FirebaseAuthViewController: UIViewController, FUIAuthDelegate {

    var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        
        self.authUI?.providers = providers
    }
    
    private func isUserSignedIn() -> Bool {
        if Auth.auth().currentUser == nil {return false}
        return true
    }
    
    private func showLoginScreen() {
        if !isUserSignedIn() {
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true)
        } else {
            performSegue(withIdentifier: "authSuccess", sender: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginScreen()
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let err = error {
            print("Auth Error: \(err)")
        } else {
            print("Auth Success")
            self.dismiss(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func signOut() {
        do {
            try self.authUI?.signOut()
            showLoginScreen()
        } catch {
            print("Logout operation failed")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
     _ sender: Any
    }
    */

}
