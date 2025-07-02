// ios/PaymentResultMapper.swift
import Foundation
import PortmoneSDKEcom

/// Helper class to map between Portmone's Bill and our PaymentResult
class PaymentResultMapper {
    /// Convert from PortmoneSDKEcom.Bill to PaymentResult
    static func fromBill(_ bill: PortmoneSDKEcom.Bill) -> PaymentResult {
        // Convert Date? to Double? (timestamp in milliseconds if present)
        let payDateTimestamp: Double? = bill.payDate.map { $0.timeIntervalSince1970 * 1000 }
        
        return PaymentResult(
            billId: bill.billId,
            status: bill.status,
            billAmount: bill.billAmount,
            cardMask: bill.cardMask,
            commissionAmount: bill.commissionAmount,
            receiptUrl: bill.recieptUrl,
            contractNumber: bill.contractNumber,
            payDate: payDateTimestamp,
            payeeName: bill.payeeName,
            token: bill.token
        )
    }
    
    /// Convert error to a user-friendly message
    static func errorMessageFrom(_ error: Error) -> String {
        let nsError = error as NSError
        
        // Handle known error codes
        switch nsError.code {
        case HfPortmoneError.paymentCanceled.rawValue:
            return "Payment was canceled by user"
        case HfPortmoneError.paymentDismissed.rawValue:
            return "Payment screen was dismissed"
        case HfPortmoneError.rootViewControllerNotFound.rawValue:
            return "Could not present payment screen"
        default:
            return error.localizedDescription
        }
    }
}
