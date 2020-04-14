//
//  LoginViewModel.swift
//  Neostore
//
//  Created by Neosoft on 31/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import Foundation
import Combine



struct LoginModel : Decodable {
    let status : Int?
    let data : DataDict?
    let message : String?
    let user_msg : String?
}


struct DataDict: Codable {
    let id : Int?
    let role_id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let username : String?
    let profile_pic : String?
    let country_id : String?
    let gender : String?
    let phone_no : String?
    let access_token : String?
}

enum EmailCheck:String {
       case valid
       case empty
       case allOk
   }
   

class LoginViewModel:ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    //o/p
    @Published var emailMessage = "Required"
    @Published var passwordMessage = "Required"
    
    @Published var isValid = false
    @Published var showAlert = false
    @Published var errorOrSuceesMsg = ""
    @Published var isShowing = false

    private var cancellableSet: Set<AnyCancellable> = []
    
    private var searchCancellable : Cancellable?  {
            didSet {
                oldValue?.cancel()
            }
        }
        
        deinit {
            searchCancellable?.cancel()
        }
    
    
    private var isUserEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email
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
            .map { (input:String) in
                return input.isValidEmail()
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
    
    
    private var isformValidPublisher:AnyPublisher<Bool,Never>{
        Publishers.CombineLatest3(isUserEmailValidPublisher,isPasswordEmptyPublisher,isPasswordEmptyPublisher)
            .map{(email,password,emailEmty) in
                return email && password && emailEmty
        }
        .eraseToAnyPublisher()
        
    }
    
 
       
   
    private var isEmailFieldValidPublisher: AnyPublisher<EmailCheck, Never> {
        Publishers.CombineLatest(isUserEmailEmptyPublisher, isUserEmailValidPublisher)
            .map { emailIsEmpty, emailValid in
                if (!emailIsEmpty) {
                    return .empty
                }
                else if(!emailValid){
                    return .valid
                }else{
                    return .allOk
                }
        }
        .eraseToAnyPublisher()
        
        
    }
    
    init() {
        
        isPasswordEmptyPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ input in
                input ? "" : "Password can't be empty"
        }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)
        
        isEmailFieldValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ input in
                switch input{
                case .empty:
                    return "Email can't be empty"
                case .valid:
                    return "Email is not valid plz check again"
                default:
                    return ""
                }
                
        }
        .assign(to: \.emailMessage, on: self)
        .store(in: &cancellableSet)
        
        
        isformValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)

        
    }
    
    func login() {
    
        self.isShowing = true
        let parameterDictionary = [
            "email" : email,
            "password": password
        ]
        
        let url=URL(string: "http://staging.php-dev.in:8844/trainingapp/api/users/login")!
        
        searchCancellable = ApiManager<LoginModel>.fetchData(url: url, parameters: parameterDictionary, method: "POST").receive(on: RunLoop.main).sink(receiveCompletion: { (completion) in
            switch completion{
            case .finished:
                break
            case .failure(let error):
                
                self.errorOrSuceesMsg = error.localizedDescription
                self.showAlert = true
                self.isShowing = false
            }
            
        }, receiveValue: { loginData in
            print(loginData)
           if loginData.status == 200{
                self.errorOrSuceesMsg = loginData.user_msg ?? ""
                self.showAlert = true
             self.isShowing = false
            }
        })
    }
}

