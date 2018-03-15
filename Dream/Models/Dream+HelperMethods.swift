//
//  Dream+HelperMethods.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 15.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

extension Dream {
    
    public func add(credits: Double) {
        self.currentCredits += credits
        CoreDataManager.sharedInstance.addTransaction(uuid: UUID().uuidString, dream: self, date: Date(), credits: credits)
    }

}
