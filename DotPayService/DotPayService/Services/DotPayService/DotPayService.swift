//
//  DotPayViewController.swift
//  WebViewDotPayment
//
//  Created by Jakub Łaszczewski on 25/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import UIKit
import WebKit

protocol DotPayServiceDelegate: UIViewController {
    func didFinishLoading()
    func didFinish()
}

protocol DotPayServiceProtocol {
    
    var delegate: DotPayServiceDelegate? { get set }
    var apiVersion: String { get set }
    var merchantId: Int { get set }
    var merchantPin: String { get set }
    var channel: Int { get set }
    var urlc: String { get set }
}

// MARK: - Protocol actions
extension DotPayServiceProtocol {
    func beginPayment(paymentModel: DotPayBeginPaymentModel, control: String? = nil) {
        let dotPayVC = DotPayViewController(delegate: delegate, apiVersion: apiVersion, merchantId: merchantId, merchantPin: merchantPin, channel: channel, urlc: urlc)
        DispatchQueue.main.async {
            self.delegate?.present(UINavigationController(rootViewController: dotPayVC), animated: true) {
                dotPayVC.beginPayment(amount: paymentModel.amount, currency: paymentModel.currency, description: paymentModel.description, control: control, ignoreLastPaymentValue: paymentModel.ignoreLastPaymentValue)
            }
        }
    }
}

// MARK: - ViewController
private final class DotPayViewController: UIViewController, WKNavigationDelegate {
    
    weak var delegate: DotPayServiceDelegate?
    weak var webView: WKWebView?
    var bottomWebViewConstraint: NSLayoutConstraint?
    var apiVersion: String
    var merchantId: Int
    var merchantPin: String
    var channel: Int
    var urlc: String
    
    override func loadView() {
        super.loadView()
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        self.webView = webView
        
        view.addSubview(webView)
        
        let bottomWebViewConstraint = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomWebViewConstraint])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.didFinishLoading()
    }
    
    init(delegate: DotPayServiceDelegate?, apiVersion: String, merchantId: Int, merchantPin: String, channel: Int, urlc: String) {
        self.delegate = delegate
        self.apiVersion = apiVersion
        self.merchantId = merchantId
        self.merchantPin = merchantPin
        self.urlc = urlc
        self.channel = channel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Please use init(params...)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction))
        
        NotificationCenter.default.addObserver(self, selector: #selector(uiKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(uiKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - ViewController Actions
private extension DotPayViewController {
    @objc func dismissAction() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didFinish()
        }
    }
    
    func beginPayment(
        amount: Double,
        currency: String,
        description: String,
        control: String?,
        ignoreLastPaymentValue: Bool
    ) {
        guard let chk = "\(merchantPin)\(apiVersion)\(merchantId)\(amount)\(currency)\(description)\(control ?? "")\(channel)\(urlc)\(ignoreLastPaymentValue ? 1 : 0)".sha256() else { return }
        
        guard let urlString = "https://ssl.dotpay.pl/test_payment/?api_version=\(apiVersion)&id=\(merchantId)&amount=\(amount)&currency=\(currency)&description=\(description)&\(control != nil ? "control=\(control!)" : "")&channel=\(channel)&urlc=\(urlc)&ignore_last_payment_channel=\(ignoreLastPaymentValue ? 1 : 0)&chk=\(chk)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
            else { return }
        
        let urlRequest = URLRequest(url: url)
        webView?.load(urlRequest)
    }
    
    @objc func viewTapped(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func uiKeyboardWillHideNotification(_ sender: Notification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        prepareSendButtonPosition(isKeyboardOn: false, keyboardSize: keyboardSize)
    }
    
    @objc func uiKeyboardWillShowNotification(_ sender: Notification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        prepareSendButtonPosition(isKeyboardOn: true, keyboardSize: keyboardSize)
    }
    
    func prepareSendButtonPosition(isKeyboardOn: Bool, keyboardSize: CGRect) {
        if isKeyboardOn {
            bottomWebViewConstraint?.constant = keyboardSize.height - view.safeAreaInsets.bottom
        } else {
            bottomWebViewConstraint?.constant = 0
        }
        UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        })
    }
}
