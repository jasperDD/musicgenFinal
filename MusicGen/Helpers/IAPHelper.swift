//
//  IAPHelper.swift
//  MusicGen
//
//  Created by Kartinin Studio on 21.07.2021.
//

import UIKit
import StoreKit
import Alamofire

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void


extension Notification.Name {
  static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
  static let IAPHelperRestoreNotification = Notification.Name("IAPHelperRestoreNotification")
}

open class IAPHelper: NSObject  {

    
  private let productIdentifiers: Set<ProductIdentifier>
  private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    for productIdentifier in productIds {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        print("Previously purchased: \(productIdentifier)")
        //lockProduct = 15
      } else {
        print("Not purchased: \(productIdentifier)")
        //lockProduct = 2
      }
    }
    super.init()

    SKPaymentQueue.default().add(self)
  }
}

// MARK: - StoreKit API

extension IAPHelper {
  
  public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct) {
    print("Buying \(product.productIdentifier)...")
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
    
    /*let queue = SKPaymentQueue.default()
    if queue.transactions.count == 0 {
        print("restore something")
     }*/
   
  }

}

// MARK: - SKProductsRequestDelegate
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("Loaded list of products...")
    let productss = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()
    products.append(contentsOf: productss)

    for p in products {
        print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue) \(p.priceLocale)")
        let price = NSString(format: "%.0f", p.price.floatValue)
        productPrice = "\(price as String) "
    
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = p.priceLocale
        productPrice += formatter.currencyCode
        productPrice += AppHelper.getLocalizeString(str: "/\n1 год")
    }
  }

  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver


extension IAPHelper: SKPaymentTransactionObserver {
  

  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
         complete(transaction: transaction)
        // lockProduct = 15
        
       
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        if transaction.original?.transactionIdentifier != nil { // this identifier uniquely identifies a completed tansaction.
            //checkRestoreFailed = false
            restore(transaction: transaction)
            //queue.restoreCompletedTransactions()

                print("THE BUYER BOUGHT THIS PRODUCT BEFORE")
            //lockProduct = 15
            //checkPaymentBefore = true
            deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)

            } else {
             /*
              display UIAlertController showing an error
              there is no receipts, user never purchased this product.
                                */
            //checkPaymentBefore = false
            deliverRestoreNotificationFor(identifier: transaction.payment.productIdentifier)
            print("THE BUYER not BOUGHT yet")
            }
        
        break
      case .deferred:
        break
      case .purchasing:
        print("Something")
        break
      @unknown default:
        print("Failed payment")
        }
    }
  }

  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

    print("restore... \(productIdentifier)")
   // lockProduct = 15
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
    
  }

  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
        transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(localizedDescription)")
      }

    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }

    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
  }
    private func deliverRestoreNotificationFor(identifier: String?) {
      guard let identifier = identifier else { return }

      //purchasedProductIdentifiers.insert(identifier)
      //UserDefaults.standard.set(true, forKey: identifier)
      NotificationCenter.default.post(name: .IAPHelperRestoreNotification, object: identifier)
    }
}


