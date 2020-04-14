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
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUserFirstNameValidPublisher: AnyPublisher<Bool, Never> {
        $firstName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    private var isUserLastNameValidPublisher: AnyPublisher<Bool, Never> {
        $lastName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    private var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count >= 3
        }
        .eraseToAnyPublisher()
    }
    private var isConfirmPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $confirmPassword
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
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
    
    //      private var passwordStrengthPublisher: AnyPublisher<PasswordStrength, Never> {
    //        $password
    //          .debounce(for: 0.2, scheduler: RunLoop.main)
    //          .removeDuplicates()
    //          .map { input in
    //            return Navajo.strength(ofPassword: input)
    //          }
    //          .eraseToAnyPublisher()
    //      }
    //
    //      private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
    //        passwordStrengthPublisher
    //          .map { strength in
    //            print(Navajo.localizedString(forStrength: strength))
    //            switch strength {
    //            case .reasonable, .strong, .veryStrong:
    //              return true
    //            default:
    //              return false
    //            }
    //          }
    //          .eraseToAnyPublisher()
    //      }
    
    //      enum PasswordCheck {
    //        case valid
    //        case empty
    //        case noMatch
    //        case notStrongEnough
    //      }
    
    //      private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
    //        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongEnoughPublisher)
    //          .map { passwordIsEmpty, passwordsAreEqual, passwordIsStrongEnough in
    //            if (passwordIsEmpty) {
    //              return .empty
    //            }
    //            else if (!passwordsAreEqual) {
    //              return .noMatch
    //            }
    //            else if (!passwordIsStrongEnough) {
    //              return .notStrongEnough
    //            }
    //            else {
    //              return .valid
    //            }
    //          }
    //          .eraseToAnyPublisher()
    //      }
    ////
    //      private var isFormValidPublisher: AnyPublisher<Bool, Never> {
    //        Publishers.CombineLatest(isUserEmailValidPublisher, isPasswordValidPublisher)
    //          .map { userNameIsValid, passwordIsValid in
    //            return userNameIsValid && (passwordIsValid == .valid)
    //          }
    //        .eraseToAnyPublisher()
    //      }
    
    init() {
        
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
        .assign(to: \.confirmPassword, on: self)
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
        
        
        
        
        
        
        //        isPasswordValidPublisher
        //          .receive(on: RunLoop.main)
        //          .map { passwordCheck in
        //            switch passwordCheck {
        //            case .empty:
        //              return "Password must not be empty"
        //            case .noMatch:
        //              return "Passwords don't match"
        //            case .notStrongEnough:
        //              return "Password not strong enough"
        //            default:
        //              return ""
        //            }
        //          }
        //          .assign(to: \.passwordMessage, on: self)
        //          .store(in: &cancellableSet)
        
        arePasswordsEqualPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            
            .map { valid in
                valid ? "" : "password doesn't matches"
        }
        .assign(to: \.confirmPassword, on: self)
        .store(in: &cancellableSet)
        
        
        //.assign(to: \.isValid, on: self)
        // .store(in: &cancellableSet)
    }
    
    
    //    func fetch() {
    //        let para=[
    //            "first_name": "Ka",
    //            "last_name": "Mara",
    //            "email": "a5@gmail.com",
    //            "password": "Kannan123",
    //            "confirm_password": "Kannan123",
    //            "gender": "M",
    //           "phone_no": "8765434567"
    //        ]
    //
    //           let url = URL(string: "http://staging.php-dev.in:8844/trainingapp/api/users/register")
    //           guard let urlMain = url else{return}
    //           var request = URLRequest(url: urlMain)
    //           request.httpMethod = "POST"
    //
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //
    //
    //
    //          //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.httpBody = para.percentEncoded()
    //
    //
    //
    //
    //          // let jsonData = try! JSONSerialization.data(withJSONObject: para, options: [])
    //
    //           URLSession.shared.dataTask(with: request){(data, response, error) in
    //               guard let httpResponse = response as? HTTPURLResponse  else{return}
    //               if error == nil{
    //                   if let safeData = data{
    //                       let decoder = JSONDecoder()
    //                       do{
    //                           let result =  try decoder.decode(RegistrationModel.self, from: safeData)
    //                           DispatchQueue.main.async {
    //
    //
    //                            //completion(result)
    //                           }
    //                       }
    //                       catch{
    //                           print(error)
    //                       }
    //                   }
    //               }
    //        }.resume()
    //
    //}
    //
}


