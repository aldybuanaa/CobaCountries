//
//  loginViewModel.swift
//  CobaLogin
//
//  Created by developer on 16/01/23.
//

import Foundation
import RxSwift


class LoginViewModel {
    let usernameTextPublishSubject:BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordTextPublishSubject:BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var isValidUsername:Observable<Bool> {
        usernameTextPublishSubject.map { username in
            return username.validateUsername()
        }
    }
    
    var isValidPassword:Observable<Bool> {
        passwordTextPublishSubject.map { password in
            return password.validatePassword()
        }
    }

    var isValidInput:Observable<Bool> {
        return Observable.combineLatest(isValidUsername, isValidPassword).map({ $0 && $1 })
    }
    
    func errorUsername(username: String) -> String {
        if !(username.validateUsername()) {
            return "Email tidak valid"
        }
        else {
            return ""
        }
    }
    
    func errorPassword(password: String) -> String {
        if !(password.validatePassword()) {
            return "Password minimal 8 karakter, 1 Huruf Besar, 1 Huruf kecil, dan 1 Symbol"
        } else {
            return ""
        }
    }
    
    
}


extension String {
    func validateUsername() -> Bool {
        let usernameRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return predicate.evaluate(with: self)
    }
    
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[#?!@$%^&*-]).{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: self)
    }
}
