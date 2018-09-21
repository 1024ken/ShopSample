//
//  String+Validate.swift
//  ShopSample
//
//  Created by 渡辺健一 on 2018/02/27.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import Foundation

extension String {
    
    func isOnlyNumber() -> Bool {
        return self.isEmptyMatches(pattern: "[^a-zA-Z0-9]+")
    }
    
    func isAvailableEmail() -> Bool {
        
        if self.characters.count == 0 {
            return false
        }
        if self.characters.count > 255 {
            return false
        }
        if !self.contains("@") {
            return false
        }
        let separated = self.components(separatedBy: "@")
        if separated.count != 2 {
            return false
        }
        if separated[0].characters.count == 0 || separated[1].characters.count == 0 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^a-zA-Z0-9@\\+_\\-\\.]+")
    }
    
    func isAvailablePassword() -> Bool {
        
        if self.characters.count < 3 {
            return false
        }
        if self.characters.count > 255 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^a-zA-Z0-9]+")
    }
    
    func isAvailableName() -> Bool {
        
        if self.characters.count == 0 {
            return false
        }
        if self.characters.count > 255 {
            return false
        }
        return true
    }
    
    func isAvailablePostCode() -> Bool {
        
        if (self.characters.count != 7) && (self.characters.count != 8) {
            return false
        }
        return self.isEmptyMatches(pattern: "[^0-9\\-]")
    }
    
    func isAvailableAddress() -> Bool {
        
        if self.characters.count == 0 {
            return false
        }
        if self.characters.count > 255 {
            return false
        }
        return true
    }
    
    func isAvailablePhoneNumber() -> Bool {
        
        if self.characters.count < 11 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^0-9\\-\\+\\(\\)]+")
    }
    
    func isAvailableCreditCardNumber() -> Bool {
        
        if self.characters.count != 16 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^0-9]+")
    }
    
    func isAvailableCreditCardExpire() -> Bool {
        
        let separated = self.components(separatedBy: "/")
        if separated.count != 2 {
            return false
        }
        
        guard let month = Int(separated[0].replacingOccurrences(of: " ", with: "")),
            let year = Int(separated[1].replacingOccurrences(of: " ", with: "")) else {
            return false
        }
        if (month <= 0) || (month > 12) {
            return false
        }
        if (year <= 0) {
            return false
        }
        return true
    }
    
    func isAvailableCreditCardCvc() -> Bool {
        
        if self.characters.count != 3 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^0-9]+")
    }
    
    func isAvailableCreditCardName() -> Bool {
        
        if self.characters.count == 0 {
            return false
        }
        return self.isEmptyMatches(pattern: "[^a-zA-Z0-9]+", options: .allowCommentsAndWhitespace)
    }
    
    private func isEmptyMatches(pattern: String, options: NSRegularExpression.Options = .caseInsensitive) -> Bool {
        
        do {
            let expression = try NSRegularExpression(pattern: pattern, options: options)
            let matches = expression.matches(in: self,
                                             options: NSRegularExpression.MatchingOptions(),
                                             range: NSRange(location: 0, length: characters.count))
            return matches.isEmpty
        } catch {
            print(error)
        }
        
        return false
    }
}
