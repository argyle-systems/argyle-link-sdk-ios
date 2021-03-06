//
//  ViewController.swift
//  ArgyleExample
//
//  Created on 26/08/2019.
//  Copyright © 2019 argyle. All rights reserved.
//

import UIKit
import ArgyleLink

class ViewController: UIViewController {

    let EXISTING_USER_TOKEN_KEY = "EXISTING_USER_TOKEN_KEY"
    let PLUGIN_KEY = "YOUR_PLUGIN_KEY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArgyleWithPayDistribution()
    }
    
    private func setupArgyleBasic() {
        _ = Argyle.shared
            .loginWith(pluginKey: PLUGIN_KEY, apiHost: "https://api-sandbox.argyle.io/v1")
//            .linkItems(["uber"]) // uncomment to limit the number of Link items that users can connect
            .resultListener(self)
    }
    
    private func setupArgyleWithPayDistribution() {
        let PD_CONFIG = "YOUR_ENCRYPTED_PD_CONFIG" // More info: https://argyle.com/docs/pay-distributions-guide/link-integration
        _ = Argyle.shared
            .loginWith(pluginKey: PLUGIN_KEY, apiHost: "https://api-sandbox.argyle.io/v1")
            .payDistributionUpdateFlow(true)
            .payDistributionConfig(PD_CONFIG)
            .payDistributionItemsOnly(true)
            .resultListener(self)
    }

    @IBAction func argyleNewUser(_ sender: Any) {
        let argyle = Argyle.shared.updateToken("").controller
        argyle.modalPresentationStyle = .fullScreen
        self.present(argyle, animated: true, completion: nil)
    }

    @IBAction func argyleExistingUser(_ sender: Any) {
        if let token = UserDefaults.standard.value(forKey: EXISTING_USER_TOKEN_KEY) as? String {
            let argyle = Argyle.shared.updateToken(token).controller
            argyle.modalPresentationStyle = .fullScreen
            self.present(argyle, animated: true, completion: nil)
        } else {
            showNoExistingToken()
        }
    }

    func showNoExistingToken() {
        let alert = UIAlertController(title: "Error!", message: "No stored user token found.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel , handler:{ (UIAlertAction)in

        }))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: ArgyleResultListener {
    func onAccountCreated(accountId: String, userId: String, linkItemId:String) {
        print("APP: onAccountCreated(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }

    func onAccountConnected(accountId: String, userId: String, linkItemId:String) {
        print("APP: onAccountConnected(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }

    func onAccountUpdated(accountId: String, userId: String, linkItemId:String) {
        print("APP: onAccountUpdated(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }

    func onAccountRemoved(accountId: String, userId: String, linkItemId:String) {
        print("APP: onAccountRemoved(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }
    
    func onPayDistributionSuccess(accountId: String, userId: String, linkItemId: String) {
        print("APP: onPayDistributionSuccess(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }
    
    func onPayDistributionError(accountId: String, userId: String, linkItemId: String) {
        print("APP: onPayDistributionError(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }

    func onUserCreated(token: String, userId: String) {
        print("APP: onWorkerCreated((token: \(token), userId: \(userId))")
        UserDefaults.standard.set(token, forKey: EXISTING_USER_TOKEN_KEY)
    }

    func onError(error: ArgyleErrorType) {
        print("APP: onError(error: \(error.rawValue))")
    }

    func onTokenExpired(handler: @escaping (String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            handler("New token")
        }
    }

    func onAccountError(accountId: String, userId: String, linkItemId: String) {
        print("APP: onAccountError(accountId: \(accountId), userId: \(userId), linkItemId: \(linkItemId))")
    }

    func onClose() {
        print("APP: onClose")
    }

}
