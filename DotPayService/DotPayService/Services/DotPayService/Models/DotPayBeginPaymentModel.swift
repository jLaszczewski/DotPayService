//
//  DotPayBeginPaymentModel.swift
//  WebViewDotPayment
//
//  Created by Jakub Łaszczewski on 25/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import Foundation

protocol DotPayBeginPaymentModel {
    
    var amount: Double { get set }
    var currency: String { get set }
    var description: String { get set }
    var ignoreLastPaymentValue: Bool { get set }
}
