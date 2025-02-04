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
                print("Transaction successful!")
            }else if transaction.transactionState == .failed {
                //Payment failed
                print("Transaction failed!")
                
            }
        }
    }
    
}
