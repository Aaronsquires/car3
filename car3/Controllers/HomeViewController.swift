//
//  HomeViewController.swift
//  car3
//
//  Created by Aaron squires on 28/03/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var LogOutButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    
    
    func setUpElements() {
        Utilities.styleFilledButton(LogOutButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    

    @IBAction func LogOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let welcomeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.WelcomeViewController) as? ViewController
            self.view.window?.rootViewController = welcomeViewController
            self.view.window?.makeKeyAndVisible()
        } catch let err {
            print("Failed to sign out with error: ",err)
        }
    }
}
