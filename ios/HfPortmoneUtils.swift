// ios/HfPortmoneUtils.swift
import Foundation
import PortmoneSDKEcom

// Helper function to convert language string to PortmoneSDKEcom.Language
func convertLanguage(_ language: String?) -> PortmoneSDKEcom.Language {
    guard let language = language else {
        // Default to device language if not provided
        let currentLocale = Locale.current.language.languageCode?.identifier
        if currentLocale == "en" {
            return .english
        } else {
            return .ukrainian
        }
    }
    
    switch language {
    case "ukrainian":
        return .ukrainian
    case "english":
        return .english
    default:
        // Default to Ukrainian if an invalid language is provided
        return .ukrainian
    }
}

// Helper function to convert currency string to PortmoneSDKEcom.Currency
func convertCurrency(_ currency: String?) -> PortmoneSDKEcom.Currency {
    guard let currency = currency else {
        return .uah // Default to UAH if not provided
    }
    
    switch currency {
    case "UAH":
        return .uah
    case "USD":
        return .usd
    case "EUR":
        return .eur
    case "GBP":
        return .gbp
    case "BYN":
        return .byn
    case "KZT":
        return .kzt
    default:
        return .uah // Default to UAH if an invalid currency is provided
    }
}

// Helper function to convert payment type string to PortmoneSDKEcom.PaymentType
func convertPaymentType(_ type: String?) -> PortmoneSDKEcom.PaymentType {
    guard let type = type else {
        return .payment // Default to payment if not provided
    }
    
    switch type {
    case "payment":
        return .payment
    case "mobilePayment":
        return .mobilePayment
    case "account":
        return .account
    default:
        return .payment // Default to payment if an invalid type is provided
    }
}

// Helper function to generate a unique bill number if one is not provided
func generateBillNumber() -> String {
    return "SDK\(Int(Date().timeIntervalSince1970))"
}

// Helper extension to log errors to console
extension Error {
    func logError(prefix: String = "HfPortmone Error") {
        let nsError = self as NSError
        print("\(prefix): \(nsError.localizedDescription) (code: \(nsError.code))")
        if let reason = nsError.localizedFailureReason {
            print("Reason: \(reason)")
        }
    }
}