//
//  OvertimeDay.swift
//  WageKeeper
//
//  Created by Maikzy on 2019-03-22.
//  Copyright © 2019 Bartek . All rights reserved.
//

import Foundation

class OvertimeDay {
    var day: String!
    var rules: [OvertimeRule]!
    
    init(day: String, rules: [OvertimeRule]) {
        self.day = day
        self.rules = rules
    }
    
    func toJSON() -> [Any] {
        var json = [Any]()
        
        for rule in rules {
            json.append(rule.json())
        }
        return json
    }
    
    func equals(another: OvertimeDay) -> Bool {
        let dayIsSame = self.day == another.day
        let sameAmountOfRules = self.rules.count == another.rules.count
        var rulesAreSame = true
        
        if sameAmountOfRules {
            for i in 0..<self.rules.count {
                let rule1 = self.rules[i]
                let rule2 = another.rules[i]
                
                if !rule1.equals(another: rule2) {
                    rulesAreSame = false
                    break;
                }
            }
        }
        
        return dayIsSame && sameAmountOfRules && rulesAreSame
    }
}
