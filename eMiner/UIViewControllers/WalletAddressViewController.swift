//
//  WalletAddressViewController.swift
//  eMiner
//
//  Created by Issarapong Poesua on 5/28/2560 BE.
//  Copyright © 2560 Issarapong Poesua. All rights reserved.
//

import UIKit
import RealmSwift

class WalletAddressViewController: UIViewController
{
    var service: ServiceModel {
        get {return AddServiceSingleton.sharedInstance.serviceModel }
    }
    
    @IBOutlet weak var walletAddressTextField: UITextField!
    var walletAddress:String { return walletAddressTextField.text ?? ""}
    
    @IBAction func submit(_ sender: UIBarButtonItem)
    {
        if(walletAddress != "")
        {
        AddServiceSingleton
            .sharedInstance
            .serviceModel
            .address = self.walletAddress
        
        self.addServiceToRealm(poolName: self.service.poolname,
                               currency: self.service.currency,
                               address: self.service.address)
        }
        else
        {
            showAlert(title: "Something went wront", message: "Please fill your wallet address", button: "OK")
        }
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        walletAddressTextField.placeholder = "Your \(service.currency) Wallet Address"
        
        walletAddressTextField.becomeFirstResponder()
        
    }
    
    func showAlert(title: String, message: String, button: String)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: button,
                                      style: .default,
                                      handler: nil))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    func addServiceToRealm(poolName: String, currency: String, address: String)
    {
        let realm = try! Realm()
        
        let service = ServiceModel()
        service.id = randomString(length: 20)
        service.address = address
        service.currency = currency
        service.poolname = poolName
        
        
        try! realm.write {
            realm.add(service)
        }
        
        AddServiceSingleton.sharedInstance.clear()
        self.dismiss(animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    
}
