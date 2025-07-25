///
/// HybridHfPortmoneSpec.swift
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

import Foundation
import NitroModules

/// See ``HybridHfPortmoneSpec``
public protocol HybridHfPortmoneSpec_protocol: HybridObject {
  // Properties
  

  // Methods
  func initialize(styleOptions: StyleOptions?, language: Language?) throws -> Void
  func setTimeout(timeoutMs: Double) throws -> Void
  func payByCard(params: PaymentParams, showReceiptScreen: Bool?) throws -> Promise<PaymentResult>
  func payByToken(payParams: PaymentParams, tokenParams: TokenPaymentParams, showReceiptScreen: Bool?) throws -> Promise<PaymentResult>
  func saveCard(params: PreauthParams) throws -> Promise<PaymentResult>
  func setReturnToDetailsDisabled(disabled: Bool) throws -> Void
}

/// See ``HybridHfPortmoneSpec``
public class HybridHfPortmoneSpec_base {
  private weak var cxxWrapper: HybridHfPortmoneSpec_cxx? = nil
  public func getCxxWrapper() -> HybridHfPortmoneSpec_cxx {
  #if DEBUG
    guard self is HybridHfPortmoneSpec else {
      fatalError("`self` is not a `HybridHfPortmoneSpec`! Did you accidentally inherit from `HybridHfPortmoneSpec_base` instead of `HybridHfPortmoneSpec`?")
    }
  #endif
    if let cxxWrapper = self.cxxWrapper {
      return cxxWrapper
    } else {
      let cxxWrapper = HybridHfPortmoneSpec_cxx(self as! HybridHfPortmoneSpec)
      self.cxxWrapper = cxxWrapper
      return cxxWrapper
    }
  }
}

/**
 * A Swift base-protocol representing the HfPortmone HybridObject.
 * Implement this protocol to create Swift-based instances of HfPortmone.
 * ```swift
 * class HybridHfPortmone : HybridHfPortmoneSpec {
 *   // ...
 * }
 * ```
 */
public typealias HybridHfPortmoneSpec = HybridHfPortmoneSpec_protocol & HybridHfPortmoneSpec_base
