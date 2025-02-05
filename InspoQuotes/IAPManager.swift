//
//  IAPManager.swift
//  InspoQuotes
//
//  Created by özge kurnaz on 5.02.2025.
//  Copyright © 2025 London App Brewery. All rights reserved.
//

import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    static let shared = IAPManager()
    
    var products = [SKProduct]()
    
    let productIdentifiers: Set<String> = ["com.ozgekurnaz.inspoquotes"]
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        print("Cekme basarılı")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if self.products.isEmpty {
            print("ürün Yok")
        }else{
            for product in products {
                print("Ürün var: \(product.localizedTitle)")
            }
        }
        for product in products {
            print("Ürün bulundu: \(product.localizedTitle) - \(product.price)")
        }
    }
    

    func buyPremiumQuotes(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            // create a payment request
            let paymentRequest = SKPayment(product: product )
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User can't make payments")
        }
    }
        
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            if transaction.transactionState == .purchased {
                // successfull purchase
                print("Satın alma ok")
                UserDefaults.standard.set(true, forKey: "isPremiumUser")
               
                print("IAP bildirim bsarılı")
                NotificationCenter.default.post(name: NSNotification.Name("IAPSuccess"), object: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                    
            }else if transaction.transactionState == .failed {
                //Payment failed
                print("satın alma basarısız")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }else if transaction.transactionState == .restored {
                // restore purchase
                print("restore basarılı")
                UserDefaults.standard.set(true, forKey: "isPremiumUser")
                print("Restore sonrası IAP bildirim basarılı")
                NotificationCenter.default.post(name: NSNotification.Name("IAPSuccess"), object: nil)

                print("Transaction restored!")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func isPurchased()->Bool{
        let purchaseStatus = UserDefaults.standard.bool(forKey: "isPremiumUser")
        
        if purchaseStatus{
            print("User is premium already")
            return true
        }else{
            print("User is not premium")
            return false
        }
    }
    func restorePurchases(){
        print("Storekit: restore cagrıldı.")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}
