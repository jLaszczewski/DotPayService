//
//  CreateOrderModel.swift
//  WebViewDotPayment
//
//  Created by Jakub Łaszczewski on 24/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import Foundation

struct CreateOrderModel: Codable, DotPayBeginPaymentModel {
    
    var currency: String
    var description: String
    var ignoreLastPaymentValue: Bool
    var amount: Double
    
    init(currency: String = "PLN", description: String, ignoreLastPaymentValue: Bool = true, amount: Double) {
        self.currency = currency
        self.description = description
        self.ignoreLastPaymentValue = ignoreLastPaymentValue
        self.amount = amount
    }
}
