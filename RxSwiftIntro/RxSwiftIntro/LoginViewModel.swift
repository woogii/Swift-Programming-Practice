//
//  LoginViewModel.swift
//  RxSwiftIntro
//
//  Created by siwook on 2017. 8. 19..
//  Copyright © 2017년 siwook. All rights reserved.
//

import Foundation
import RxSwift

struct LoginViewModel {
  
  var emailText = Variable<String>("")
  var passwordText = Variable<String>("")
  
  var isValid : Observable<Bool> {
    return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
      email.characters.count >= 3 && password.characters.count >= 3
    }
  }
  
}
