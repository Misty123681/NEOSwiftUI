//
//  helper.swift
//  Neostore
//
//  Created by Neosoft on 31/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import Foundation



extension String{
    func isValidEmail() -> Bool {

        print("validate emilId: \(self)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result

    }
}


