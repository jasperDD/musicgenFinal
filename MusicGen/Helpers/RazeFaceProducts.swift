//
//  RazeFaceProducts.swift
//  MusicGen
//
//  Created by Kartinin Studio on 21.07.2021.
//

import Foundation

public struct RazeFaceProducts {
  
  public static var SwiftShopping = "Donate"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [RazeFaceProducts.SwiftShopping]

  public static let store = IAPHelper(productIds: RazeFaceProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    //return productIdentifier.components(separatedBy: ".").last
    return productIdentifier
}
