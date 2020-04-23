//
//  Registration.swift
//  Neostore
//
//  Created by Neosoft on 30/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import Foundation
import Combine

struct RegistrationModel:Decodable{
    let status :Int?
    let message:String?
    let data:DataDict?
}



class RegistrationViewModel:ObservableObject{
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var  password = ""
    @Published var confirmPassword = ""
    @Published var phoneNum = ""
    @Published var gender = "F"
    
    
    // output
    @Published var firstMessage = "Required"
    @Published var lastMessage = "Required"
    @Published var emailMessage = "Required"
    @Published var passwordMessage = "Required"
    @Published var confirmMessage = "Required"
    @Published var phoneMessage = "Required"
    
    @Published var isValid = false
    @Published var showAlert = false
    @Published var errorOrSuceesMsg = ""
    @Published var isShowing = false
    @Published var isSuccess = false
    
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var searchCancellable : Cancellable?  {
        didSet {
            oldValue?.cancel()
        }
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    private var isUserFirstNameValidPublisher: AnyPublisher<Bool, Never> {
        $firstName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 1
        }
        .eraseToAnyPublisher()
    }
    private var isUserLastNameValidPublisher: AnyPublisher<Bool, Never> {
        $lastName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 1
        }
        .eraseToAnyPublisher()
    }
    
    private var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 1
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 1
        }
        .eraseToAnyPublisher()
    }
    private var isConfirmPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $confirmPassword
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 1
        }
        .eraseToAnyPublisher()
    }
    
    private var isPhoneNumEmptyPublisher: AnyPublisher<Bool, Never> {
        $phoneNum
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 10
        }
        .eraseToAnyPublisher()
    }
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
        }
        .eraseToAnyPublisher()
    }
    
    
    private var isFormValidPublisher1: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isUserFirstNameValidPublisher, isUserLastNameValidPublisher,isUserEmailValidPublisher)
            .map { firstname, lastname,email in
                return firstname && lastname && email
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher2: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isPasswordEmptyPublisher, isPhoneNumEmptyPublisher,isConfirmPasswordEmptyPublisher,isPasswordEmptyPublisher)
            .map { a,b,c,d in
                return a && b && c && d
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isFormValidPublisher1, isFormValidPublisher2)
            .map { form1,form2 in
                return form1 && form2
        }
        .eraseToAnyPublisher()
    }
    
    
    
    init() {
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        
        isUserFirstNameValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { valid in
                valid ? "" : "name can't be empty"
        }
        .assign(to: \.firstMessage, on: self)
        .store(in: &cancellableSet)
        
        isUserLastNameValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "name can't be empty"
        }
        .assign(to: \.lastMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordEmptyPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "Password can't be empty"
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)
        
        isConfirmPasswordEmptyPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "confirm Password can't be empty"
        }
        .assign(to: \.confirmMessage, on: self)
        .store(in: &cancellableSet)
        
        
        
        isUserEmailValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "User email must at least have 3 characters"
        }
        .assign(to: \.emailMessage, on: self)
        .store(in: &cancellableSet)
        
        isPhoneNumEmptyPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { valid in
                valid ? "" : "User phone must at least have 10 characters"
        }
        .assign(to: \.phoneMessage, on: self)
        .store(in: &cancellableSet)
        
        
        
        arePasswordsEqualPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "password doesn't matches"
        }
        .assign(to: \.confirmMessage, on: self)
        .store(in: &cancellableSet)
        
        
    }
    
    
    func fetch() {
        
        let url = URL(string: API.K_Registeration)!
        
        self.isShowing = true
        let para=[
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "confirm_password": confirmPassword,
            "gender": gender,
            "phone_no": phoneNum
        ]
        
        
        searchCancellable = ApiManager<LoginModel>.fetchData(url: url, parameters: para, method: "POST").receive(on: RunLoop.main).sink(receiveCompletion: { (completion) in
            switch completion{
            case .finished:
                break
            case .failure(let error):
                self.errorOrSuceesMsg = error.localizedDescription
                self.showAlert = true
                self.isShowing = false
                self.isSuccess = false
            }
            
        }, receiveValue: { loginData in
            print(loginData)
            if loginData.status == 200{
                self.errorOrSuceesMsg = loginData.user_msg ?? ""
                self.showAlert = true
                self.isShowing = false
                self.isSuccess = true
            }
        })
    }
}


