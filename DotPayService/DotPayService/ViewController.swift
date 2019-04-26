//
//  ViewController.swift
//  DotPayService
//
//  Created by Jakub Łaszczewski on 26/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var paymentService: PaymentService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let merchantId = 12345 // seller ID - use yours
        let merchamerchantPin = "asdfghjkl1234567890" // seller pin - use yours
        let urlc = "http://some.test.urlc/api/payments/status" // seller urlc - use yours
        paymentService = PaymentService(delegate: self, apiVersion: "dev", merchantId: merchantId, merchantPin: merchamerchantPin, channel: 0, urlc: urlc)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func payButtonTapped(_ sender: Any) {
        let createOrderModel = CreateOrderModel(description: "Za co to?", amount: 200.00)
        paymentService?.createOrder(createOrderModel: createOrderModel)
    }
}

// MARK: - DotPayServiceDelegate
extension ViewController: DotPayServiceDelegate {
    func didFinish() {
        print("finish")
    }
    
    func didFinishLoading() {
        print("Loading finished")
    }
}
