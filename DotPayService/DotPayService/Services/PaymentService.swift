//
//  DotPayService.swift
//  WebViewDotPayment
//
//  Created by Jakub Łaszczewski on 24/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import UIKit

final class PaymentService: DotPayServiceProtocol {
    
    var delegate: DotPayServiceDelegate?
    var apiVersion: String
    var merchantId: Int
    var merchantPin: String
    var channel: Int
    var urlc: String
        
    init(delegate: DotPayServiceDelegate?, apiVersion: String, merchantId: Int, merchantPin: String, channel: Int, urlc: String) {
        self.delegate = delegate
        self.apiVersion = apiVersion
        self.merchantId = merchantId
        self.merchantPin = merchantPin
        self.channel = channel
        self.urlc = urlc
    }
    
    func createOrder(createOrderModel: CreateOrderModel) {
        beginPayment(paymentModel: createOrderModel)
    }
}
