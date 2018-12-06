//
//  File.swift
//  MedicalConsultations
//
//  Created by Julio César on 2/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    convenience init(pattern: String) {
        try! self.init(pattern: pattern, options: [])
    }
}

extension String {
    
    var isValidEmail: Bool {
        return isMatching(expression: NSRegularExpression(pattern: "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"))
    }
    
    //MARK: - Private
    
    private func isMatching(expression: NSRegularExpression) -> Bool {
        return expression.numberOfMatches(in: self, range: NSRange(location: 0, length: characters.count)) > 0
    }
}
