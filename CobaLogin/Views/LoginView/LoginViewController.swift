//
//  ViewController.swift
//  CobaLogin
//
//  Created by developer on 16/01/23.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetForm()
        observeables()
        
    }
    
    private func observeables() {
        usernameTextField.becomeFirstResponder()

        usernameTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: loginViewModel.usernameTextPublishSubject)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: loginViewModel.passwordTextPublishSubject)
            .disposed(by: disposeBag)

        loginViewModel.isValidInput
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        loginViewModel.isValidInput
            .map { $0 ? 1 : 0.1 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    func resetForm() {
        usernameError.isHidden = false
        passwordError.isHidden = false
        
        usernameError.text = ""
        passwordError.text = ""
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func usernameChange(_ sender: Any) {
        
        let username = usernameTextField.text
        usernameError.text = loginViewModel.errorUsername(username: username ?? "")
    }
    
    @IBAction func passwordChange(_ sender: Any) {
        
        let password = passwordTextField.text
        passwordError.text = loginViewModel.errorPassword(password: password ?? "")
    }
    
    
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        
        let nib = CountriesViewController(nibName: "Countries", bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.pushViewController(nib, animated: true)
    }
    

    
}
