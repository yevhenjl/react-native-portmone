// ios/HfPortmoneError.swift
import Foundation

enum HfPortmoneError: Int {
    case rootViewControllerNotFound = 1
    case paymentGenericError = 2
    case paymentDismissed = 3
    case paymentCanceled = 4
    case invalidParameters = 5
    case portmoneError = 6

    var message: String {
        switch self {
        case .rootViewControllerNotFound:
            return "Could not find root view controller to present payment screen"
        case .paymentGenericError:
            return "Payment failed with no error or bill information"
        case .paymentDismissed:
            return "Payment screen was dismissed"
        case .paymentCanceled:
            return "Payment was canceled by user"
        case .invalidParameters:
            return "Invalid payment parameters"
        case .portmoneError:
            return "Portmone SDK reported an error"
        }
    }

    var nsError: NSError {
        return NSError(
            domain: "HfPortmone",
            code: self.rawValue,
            userInfo: [NSLocalizedDescriptionKey: self.message]
        )
    }
}
