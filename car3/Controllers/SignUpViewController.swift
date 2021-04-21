//
//  SignUpViewController.swift
//  car3
//
//  Created by Aaron squires on 28/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var FullNameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var ChildBirthdayTextField: UITextField!
    
    @IBOutlet weak var CreateAccountTextField: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var HaveAccountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        let backImage = UIImage(named: "icon-back")

        self.navigationController?.navigationBar.backIndicatorImage = backImage

        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        setUpElements()


        
        

        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        ErrorLabel.alpha = 0
        Utilities.styleTextField(FullNameTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleTextField(ChildBirthdayTextField)
        Utilities.styleFilledButton(CreateAccountTextField)
    }
    
    //checks the fields and validates data. if correct method returns nil otherwise returns an error message
    func validateFields() -> String? {
        
        //check fields are filled in
        if FullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ChildBirthdayTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //check password secure
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password not secure
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        
        if error != nil {
            //something wrong
            showError(error!)
        } else {
            //clean data
            let fullName = FullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let childBirthday = ChildBirthdayTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil {
                    //there was an error
                    self.showError("Error creating user")
                } else {

                    
                    //user created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["fullname": fullName, "childbirthday":childBirthday, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //error saving user data
                            self.showError("Database error")
                        }
                        
                    }
                    
                    //transition to home
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}
