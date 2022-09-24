//
//  ViewController.swift
//  ShoppingList
//
//  Created by Eric Alves Brito.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import Firebase

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var buttonCreateAccount: UIButton!
    
    // MARK: - Properties
    private lazy var auth = Auth.auth()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelCopyright.text = RemoteConfigValues.shared.copyrightMessage
        buttonCreateAccount.isHidden = !RemoteConfigValues.shared.showCreateAccount
    }
    
    // MARK: - IBActions
    @IBAction func signIn(_ sender: Any) {
        auth.signIn(withEmail: textFieldEmail.text!,
                    password: textFieldPassword.text!) { result, error in
            
            if let error = error {
                let authErrorCode = AuthErrorCode.Code(rawValue: error._code)
                switch authErrorCode {
                case .invalidEmail:
                    print("Você colocou um e-mail inválido!")
                case .wrongPassword:
                    print("Você errou a senha")
                default:
                    print("Erro desconhecido!")
                }
            } else {
                guard let user = result?.user else { return }
                self.updateUserAndProceed(user: user)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        auth.createUser(withEmail: textFieldEmail.text!,
                        password: textFieldPassword.text!) { result, error in
            
            if let error = error {
                let authErrorCode = AuthErrorCode.Code(rawValue: error._code)
                switch authErrorCode {
                case .invalidEmail:
                    print("Você colocou um e-mail inválido!")
                case .emailAlreadyInUse:
                    print("Essa conta já existe!")
                case .weakPassword:
                    print("Esta senha é muito fraca")
                default:
                    print("Erro desconhecido!")
                }
            } else {
                guard let user = result?.user else { return }
                self.updateUserAndProceed(user: user)
            }
        }
    }
    
    // MARK: - Methods
    private func updateUserAndProceed(user: User) {
        if let name = textFieldName.text, !name.isEmpty {
            let request = user.createProfileChangeRequest()
            request.displayName = name
            request.commitChanges { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                self.gotoMainScreen()
            }
        } else {
            gotoMainScreen()
        }
    }
    
    private func gotoMainScreen() {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") {
            show(viewController, sender: nil)
        }
    }
}

