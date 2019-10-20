//
//  ViewController.swift
//  Split
//
//  Created by Vineeth Puli on 10/19/19.
//  Copyright © 2019 HackSquad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let usernameText = usernameTextField.text else {return}
        if !usernameText.isEmpty {
            UserDefaults.standard.set(usernameText, forKey: "username")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
}

