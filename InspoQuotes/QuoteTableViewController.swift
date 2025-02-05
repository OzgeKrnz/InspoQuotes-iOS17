//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import StoreKit
import UIKit

class QuoteTableViewController: UITableViewController{

    
    
    let productID = "com.londonappbrewery.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "InspoQuotes"
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue, UIColor.magenta])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restoreQuotes))
        
        //Storekitten ürünleri çekme
        IAPManager.shared.fetchProducts()
        
        //satın alma ve restore işlemlerini dinleme
        SKPaymentQueue.default().add(IAPManager.shared)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unlockPremiumQuotes), name: NSNotification.Name("IAPSuccess"), object: nil)
     
        
        // premium acma
        // StoreKit ürünleri çekildikten sonra satın alma durumunu kontrol et
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if IAPManager.shared.isPurchased() {
                print("🔓 Kullanıcı premium, premium içerikler açılıyor!")
                self.unlockPremiumQuotes()
            } else {
                print("❌ Kullanıcı premium değil.")
            }
        }
    }
    
    
    
    
    @objc func restoreQuotes() {
        print("restore butonu calıstı")
        IAPManager.shared.restorePurchases()
        
        if IAPManager.shared.isPurchased(){
            NotificationCenter.default.addObserver(self, selector: #selector(unlockPremiumQuotes), name: NSNotification.Name("IAPSuccess"), object: nil)
            
        }
        
    }
    
    @objc func unlockPremiumQuotes() {
        guard !quotesToShow.contains(premiumQuotes.first!) else { return }
        print("premium acılıyor")
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if IAPManager.shared.isPurchased() {
            return quotesToShow.count
            
        }
        return quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InspoQuotesCell", for: indexPath)
        
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = UIColor.link
            cell.accessoryType = .disclosureIndicator
        }
        
       
        
        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            // In-app purchase
            if let product = IAPManager.shared.products.first {
                IAPManager.shared.buyPremiumQuotes(product: product)
            }else{
                print("No product found")
            
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
}
