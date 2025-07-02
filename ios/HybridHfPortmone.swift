// ios/HybridHfPortmone.swift
import Foundation
import NitroModules
import UIKit
import PortmoneSDKEcom

class HybridHfPortmone: HybridHfPortmoneSpec {
    // MARK: - Properties
    
    // Configuration properties
    private var styleSourceObject: StyleSourceObject?
    private var language: PortmoneSDKEcom.Language = .ukrainian
    private var disableReturnToDetails: Bool = false
    private var customUid: String?
    private var biometricAuth: Bool = false
    
    // Strong references to prevent garbage collection during payment flow
    private var activePresenter: PaymentPresenter?
    private var activeDelegate: PaymentDelegate?
    
    // Timeout properties
    private var timeoutTimer: Timer?
    private var timeoutInterval: TimeInterval = 60 * 60 // Default: 1 hour in seconds
    
    // Temporary window reference for presentation (if needed)
    private var tempWindow: UIWindow?
    
    // MARK: - Initialization
    
    func initialize(styleOptions: StyleOptions?, language: Language?) throws {
        // Create style source safely
        if Thread.isMainThread {
            self.styleSourceObject = StyleSourceObject(styleOptions: styleOptions)
        } else {
            DispatchQueue.main.sync {
                self.styleSourceObject = StyleSourceObject(styleOptions: styleOptions)
            }
        }
        
        // Set language
        if let lang = language {
            switch lang {
            case .ukrainian:
                self.language = .ukrainian
            case .english:
                self.language = .english
            default:
                self.language = .ukrainian
            }
        }
    }
    
    // MARK: - Payment Methods
    
    func payByCard(params: PaymentParams, showReceiptScreen: Bool?) throws -> Promise<PaymentResult> {
        let promise = Promise<PaymentResult>()
        
        // Clean up any previous session
        cleanupPreviousSession()
        
        // Convert params outside of thread-related code
        let paymentParams: PortmoneSDKEcom.PaymentParams
        do {
            paymentParams = try convertPaymentParams(params)
        } catch {
            promise.reject(withError: error)
            return promise
        }
        
        // Create delegate that holds a reference to the promise
        let delegate = PaymentDelegate(promise: promise)
        self.activeDelegate = delegate
        
        // Dispatch UI operations to main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                promise.reject(withError: NSError(
                    domain: "HfPortmone",
                    code: 999,
                    userInfo: [NSLocalizedDescriptionKey: "Object was deallocated during payment initialization"]
                ))
                return
            }
            
            // Create presenter and store reference
            let presenter = PaymentPresenter(
                delegate: delegate,
                styleSource: self.styleSourceObject,
                language: self.language,
                biometricAuth: self.biometricAuth,
                customUid: self.customUid
            )
            self.activePresenter = presenter
            
            // Apply settings
            if self.disableReturnToDetails {
                presenter.setReturnToDetails(disabled: self.disableReturnToDetails)
            }
            
            // Use the enhanced presentation method
            self.presentPaymentScreen(
                presenter: presenter,
                params: paymentParams,
                showReceiptScreen: showReceiptScreen ?? true,
                promise: promise
            )
        }
        
        return promise
    }
    
    func payByToken(payParams: PaymentParams, tokenParams: TokenPaymentParams, showReceiptScreen: Bool?) throws -> Promise<PaymentResult> {
        let promise = Promise<PaymentResult>()
        
        // Clean up any previous session
        cleanupPreviousSession()
        
        // Convert params outside of thread-related code
        let paymentParams: PortmoneSDKEcom.PaymentParams
        do {
            paymentParams = try convertPaymentParams(payParams)
        } catch {
            promise.reject(withError: error)
            return promise
        }
        
        let tokenPaymentParams = PortmoneSDKEcom.TokenPaymentParams(
            cardNumberMasked: tokenParams.cardNumberMasked,
            tokenData: tokenParams.tokenData
        )
        
        // Create delegate that holds a reference to the promise
        let delegate = PaymentDelegate(promise: promise, onCompletion: { [weak self] in
            // Cancel the timeout timer when payment completes
            self?.cancelTimeoutTimer()
        })
        self.activeDelegate = delegate
        
        // Dispatch UI operations to main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                promise.reject(withError: NSError(
                    domain: "HfPortmone",
                    code: 999,
                    userInfo: [NSLocalizedDescriptionKey: "Object was deallocated during payment initialization"]
                ))
                return
            }
            
            // Create presenter and store reference
            let presenter = PaymentPresenter(
                delegate: delegate,
                styleSource: self.styleSourceObject,
                language: self.language,
                biometricAuth: self.biometricAuth,
                customUid: self.customUid
            )
            self.activePresenter = presenter
            
            // Apply settings
            if self.disableReturnToDetails {
                presenter.setReturnToDetails(disabled: self.disableReturnToDetails)
            }
            
            // Present the payment screen using the enhanced method for token payment
            self.presentTokenPaymentScreen(
                presenter: presenter,
                payParams: paymentParams,
                tokenParams: tokenPaymentParams,
                showReceiptScreen: showReceiptScreen ?? true,
                promise: promise
            )
        }
        
        return promise
    }
    
    func saveCard(params: PreauthParams) throws -> Promise<PaymentResult> {
        let promise = Promise<PaymentResult>()
        
        // Clean up any previous session
        cleanupPreviousSession()
        
        // Convert params
        let preauthParams = PortmoneSDKEcom.PreauthParams(
            payeeId: params.payeeId,
            accountId: params.accountId ?? "",
            description: params.description,
            billNumber: params.billNumber ?? ""
        )
        
        // Create delegate that holds a reference to the promise
        let delegate = PaymentDelegate(promise: promise, onCompletion: { [weak self] in
            // Cancel the timeout timer when payment completes
            self?.cancelTimeoutTimer()
        })
        self.activeDelegate = delegate
        
        // Dispatch UI operations to main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                promise.reject(withError: NSError(
                    domain: "HfPortmone",
                    code: 999,
                    userInfo: [NSLocalizedDescriptionKey: "Object was deallocated during payment initialization"]
                ))
                return
            }
            
            // Create presenter and store reference
            let presenter = PaymentPresenter(
                delegate: delegate,
                styleSource: self.styleSourceObject,
                language: self.language,
                biometricAuth: self.biometricAuth,
                customUid: self.customUid
            )
            self.activePresenter = presenter
            
            // Apply settings
            if self.disableReturnToDetails {
                presenter.setReturnToDetails(disabled: self.disableReturnToDetails)
            }
            
            // Present the preauth screen using the enhanced method
            self.presentPreauthScreen(
                presenter: presenter,
                params: preauthParams,
                promise: promise
            )
        }
        
        return promise
    }
    
    func setTimeout(timeoutMs: Double) throws {
        // Convert milliseconds to seconds
        self.timeoutInterval = timeoutMs / 1000.0
        print("Payment timeout set to \(self.timeoutInterval) seconds")
    }
    
    func setReturnToDetailsDisabled(disabled: Bool) throws {
        self.disableReturnToDetails = disabled
    }
    
    // MARK: - Enhanced Presentation Methods
    
    // Enhanced method for presenting payment by card
    private func presentPaymentScreen(
        presenter: PaymentPresenter,
        params: PortmoneSDKEcom.PaymentParams,
        showReceiptScreen: Bool,
        promise: Promise<PaymentResult>
    ) {
        // First ensure text fields are not being manipulated by keyboard controller
        forceDisconnectKeyboardController()
        
        // Add a slight delay to ensure keyboard controller has finished its operations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Find the top most view controller
            if let topVC = self.findTopViewController() {
                print("HfPortmone: Found top view controller: \(type(of: topVC))")
                
                // Present the payment screen
                presenter.presentPaymentByCard(
                    on: topVC,
                    params: params,
                    showReceiptScreen: showReceiptScreen
                )
                
                // Start the timeout timer
                self.startTimeoutTimer()
            } else {
                print("HfPortmone: Failed to find top view controller")
                promise.reject(withError: HfPortmoneError.rootViewControllerNotFound.nsError)
            }
        }
    }
    
    // Enhanced method for presenting payment by token
    private func presentTokenPaymentScreen(
        presenter: PaymentPresenter,
        payParams: PortmoneSDKEcom.PaymentParams,
        tokenParams: PortmoneSDKEcom.TokenPaymentParams,
        showReceiptScreen: Bool,
        promise: Promise<PaymentResult>
    ) {
        // First ensure text fields are not being manipulated by keyboard controller
        forceDisconnectKeyboardController()
        
        // Add a slight delay to ensure keyboard controller has finished its operations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Find the top most view controller
            if let topVC = self.findTopViewController() {
                print("HfPortmone: Found top view controller: \(type(of: topVC))")
                
                // Present the payment screen
                presenter.presentPaymentByToken(
                    on: topVC,
                    payParams: payParams,
                    tokenParams: tokenParams,
                    showReceiptScreen: showReceiptScreen
                )
                
                // Start the timeout timer
                self.startTimeoutTimer()
            } else {
                print("HfPortmone: Failed to find top view controller")
                promise.reject(withError: HfPortmoneError.rootViewControllerNotFound.nsError)
            }
        }
    }
    
    // Enhanced method for presenting preauth screen
    private func presentPreauthScreen(
        presenter: PaymentPresenter,
        params: PortmoneSDKEcom.PreauthParams,
        promise: Promise<PaymentResult>
    ) {
        // First ensure text fields are not being manipulated by keyboard controller
        forceDisconnectKeyboardController()
        
        // Add a slight delay to ensure keyboard controller has finished its operations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Find the top most view controller
            if let topVC = self.findTopViewController() {
                print("HfPortmone: Found top view controller: \(type(of: topVC))")
                
                // Present the payment screen
                presenter.presentPreauthCard(
                    on: topVC,
                    params: params
                )
                
                // Start the timeout timer
                self.startTimeoutTimer()
            } else {
                print("HfPortmone: Failed to find top view controller")
                promise.reject(withError: HfPortmoneError.rootViewControllerNotFound.nsError)
            }
        }
    }
    
    // MARK: - Timeout Methods
    
    // Start a timeout timer for the payment form
    private func startTimeoutTimer() {
        // Cancel any existing timer first
        cancelTimeoutTimer()
        
        // Create a new timer on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let minutes = Int(self.timeoutInterval / 60)
            let seconds = Int(self.timeoutInterval.truncatingRemainder(dividingBy: 60))
            
            print("Starting payment timeout timer for \(minutes) minutes and \(seconds) seconds")
            self.timeoutTimer = Timer.scheduledTimer(
                timeInterval: self.timeoutInterval,
                target: self,
                selector: #selector(self.handleTimeout),
                userInfo: nil,
                repeats: false
            )
            
            // Keep timer running even when scroll events happen (prevents timer from being invalidated during scrolling)
            RunLoop.current.add(self.timeoutTimer!, forMode: .common)
        }
    }
    
    // Cancel the timeout timer
    private func cancelTimeoutTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let timer = self.timeoutTimer, timer.isValid {
                print("Canceling payment timeout timer")
                timer.invalidate()
                self.timeoutTimer = nil
            }
        }
    }
    
    // Handle timeout by dismissing the payment form
    @objc private func handleTimeout() {
        print("Payment timeout reached - closing payment form")
        
        // Create a timeout result
        let timeoutResult = PaymentResult(
            billId: nil,
            status: "timeout",
            billAmount: 0,
            cardMask: nil,
            commissionAmount: 0,
            receiptUrl: nil,
            contractNumber: nil,
            payDate: nil,
            payeeName: nil,
            token: nil
        )
        
        // Dismiss the payment form on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let activePresenter = self.activePresenter else { return }
            
            // Dismiss the presented view controller
            if let rootViewController = self.findTopViewController() {
                rootViewController.dismiss(animated: true) {
                    // Resolve the promise with timeout result
                    self.activeDelegate?.handleTimeoutResult(timeoutResult)
                    
                    // Clean up
                    self.cleanupPreviousSession()
                }
            }
        }
    }
    
    // MARK: - Enhanced Helper Methods
    
    // Force disconnect keyboard controller from text fields
    private func forceDisconnectKeyboardController() {
        // Force any text field to resign first responder
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        // Post a notification that might be observed by keyboard controller to reset state
        NotificationCenter.default.post(name: Notification.Name("shouldIgnoreKeyboardEvents"), object: nil, userInfo: ["ignore": true])
        
        // Give a small amount of time for the notification to be processed
        Thread.sleep(forTimeInterval: 0.01)
    }
    
    // Comprehensive top view controller finder that handles all hierarchy cases
    private func findTopViewController() -> UIViewController? {
        // Must be on main thread
        assert(Thread.isMainThread, "findTopViewController must be called on the main thread")
        
        // Get all connected scenes (iOS 13+)
        var topViewController: UIViewController?
        
        if #available(iOS 13.0, *) {
            // Try to find active window scene
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive,
                   let windowScene = scene as? UIWindowScene {
                    
                    // Find the key window - prefer visible windows
                    let visibleWindows = windowScene.windows.filter { !$0.isHidden }
                    let keyWindow = visibleWindows.first { $0.isKeyWindow } 
                                  ?? visibleWindows.first
                    
                    if let rootVC = keyWindow?.rootViewController {
                        topViewController = rootVC
                        break
                    }
                }
            }
        }
        
        // Fallback for older iOS versions or if scene-based approach failed
        if topViewController == nil {
            // Try direct window access first
            let windows = UIApplication.shared.windows
            let keyWindow = windows.first { $0.isKeyWindow } ?? windows.first
            topViewController = keyWindow?.rootViewController
        }
        
        // Fallback to the deprecated keyWindow access if all else fails
        if topViewController == nil {
            topViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        guard let rootVC = topViewController else {
            print("HfPortmone: No root view controller found")
            return nil
        }
        
        // Find the visible view controller
        return findVisibleViewController(from: rootVC)
    }
    
    // Helper to find visible controller in any hierarchy
    private func findVisibleViewController(from viewController: UIViewController) -> UIViewController {
        print("HfPortmone: Traversing view controller hierarchy from \(type(of: viewController))")
        
        // Handle presented controllers - this is the most important case
        if let presentedVC = viewController.presentedViewController {
            print("HfPortmone: Found presented controller: \(type(of: presentedVC))")
            return findVisibleViewController(from: presentedVC)
        }
        
        // Navigation controllers
        if let navController = viewController as? UINavigationController {
            print("HfPortmone: Found navigation controller")
            if let visibleVC = navController.visibleViewController {
                return findVisibleViewController(from: visibleVC)
            }
            return viewController
        }
        
        // Tab bar controllers
        if let tabBarController = viewController as? UITabBarController {
            print("HfPortmone: Found tab bar controller")
            if let selectedVC = tabBarController.selectedViewController {
                return findVisibleViewController(from: selectedVC)
            }
            return viewController
        }
        
        // Page view controllers
        if let pageVC = viewController as? UIPageViewController, 
           let firstVC = pageVC.viewControllers?.first {
            print("HfPortmone: Found page view controller")
            return findVisibleViewController(from: firstVC)
        }
        
        // Split view controllers (iPad)
        if let splitVC = viewController as? UISplitViewController, 
           let firstVC = splitVC.viewControllers.first {
            print("HfPortmone: Found split view controller")
            return findVisibleViewController(from: firstVC)
        }
        
        print("HfPortmone: Using \(type(of: viewController)) as presentation controller")
        return viewController
    }
    
    // If we're really having issues, try presenting in a completely new window
    private func presentInNewWindow(presenter: PaymentPresenter, 
                                   params: PortmoneSDKEcom.PaymentParams,
                                   showReceiptScreen: Bool) {
        // Create a temporary window and present from there
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            let tempWindow = UIWindow(windowScene: windowScene)
            let rootVC = UIViewController()
            tempWindow.rootViewController = rootVC
            tempWindow.makeKeyAndVisible()
            
            self.tempWindow = tempWindow
            
            // Now present on this clean view controller
            presenter.presentPaymentByCard(
                on: rootVC,
                params: params,
                showReceiptScreen: showReceiptScreen
            )
        } else {
            let tempWindow = UIWindow(frame: UIScreen.main.bounds)
            let rootVC = UIViewController()
            tempWindow.rootViewController = rootVC
            tempWindow.makeKeyAndVisible()
            
            self.tempWindow = tempWindow
            
            // Now present on this clean view controller
            presenter.presentPaymentByCard(
                on: rootVC,
                params: params,
                showReceiptScreen: showReceiptScreen
            )
        }
    }
    
    // Clean up previous session by releasing references
    private func cleanupPreviousSession() {
        // Cancel any active timeout timer
        cancelTimeoutTimer()
        
        // Release temporary window if it exists
        if tempWindow != nil {
            DispatchQueue.main.async {
                self.tempWindow = nil
            }
        }
        
        // Release references
        self.activePresenter = nil
        self.activeDelegate = nil
    }
    
    // Helper method to convert PaymentParams
    private func convertPaymentParams(_ params: PaymentParams) throws -> PortmoneSDKEcom.PaymentParams {
        // Convert currency
        let currency: PortmoneSDKEcom.Currency
        if let currencyString = params.billCurrency {
            switch currencyString {
            case "UAH":
                currency = .uah
            case "USD":
                currency = .usd
            case "EUR":
                currency = .eur
            case "GBP":
                currency = .gbp
            case "BYN":
                currency = .byn
            case "KZT":
                currency = .kzt
            default:
                currency = .uah
            }
        } else {
            currency = .uah
        }
        
        // Convert payment type
        let paymentType: PortmoneSDKEcom.PaymentType
        if let typeString = params.type {
            switch typeString {
            case "payment":
                paymentType = .payment
            case "mobilePayment":
                paymentType = .mobilePayment
            case "account":
                paymentType = .account
            default:
                paymentType = .payment
            }
        } else {
            paymentType = .payment
        }
        
        // Generate a bill number if not provided
        let billNumber = params.billNumber ?? "SDK\(Int(Date().timeIntervalSince1970))"
        
        // Convert payment flow type
        let paymentFlowType = PortmoneSDKEcom.PaymentFlowType(
            payWithCard: params.paymentFlowType?.payWithCard ?? true,
            payWithApplePay: params.paymentFlowType?.payWithAppleGPay ?? false,
            withoutCVV: params.paymentFlowType?.withoutCVV ?? false
        )
        
        // Create payment params
        return PortmoneSDKEcom.PaymentParams(
            description: params.description ?? "",
            attribute1: params.attribute1 ?? "",
            attribute2: params.attribute2 ?? "",
            attribute3: params.attribute3 ?? "",
            attribute4: params.attribute4 ?? "",
            attribute5: params.attribute5 ?? "",
            billNumber: billNumber,
            preauthFlag: params.preauthFlag ?? false,
            billCurrency: currency,
            billAmount: params.billAmount,
            billAmountWcvv: params.billAmountWcvv ?? 0,
            payeeId: params.payeeId,
            type: paymentType,
            merchantIdentifier: params.merchantIdentifier ?? "",
            paymentFlowType: paymentFlowType
        )
    }
}

// MARK: - Payment Delegate

// Handle payment callbacks and resolve the promise
class PaymentDelegate: NSObject, PaymentPresenterDelegate {

    // Strong reference to the promise
    private let promise: Promise<PaymentResult>

    // Completion handler to be called on any payment completion
    private let onCompletion: (() -> Void)?

    private var isPromiseSettled = false
    private let settlementQueue = DispatchQueue(label: "com.hfportmone.promisesettlement.queue") // Для потокобезопасности флага

    init(promise: Promise<PaymentResult>, onCompletion: (() -> Void)? = nil) {
        self.promise = promise
        self.onCompletion = onCompletion
        super.init()
    }

    private func settlePromise(_ settlementAction: @escaping () -> Void) {
        settlementQueue.sync {
            guard !isPromiseSettled else {
                print("HfPortmone Warning: Attempted to settle an already settled promise.")
                return
            }
            isPromiseSettled = true

            ensureMainThread {
                settlementAction()
                self.onCompletion?()
            }
        }
    }

    func didFinishPayment(bill: PortmoneSDKEcom.Bill?, error: Error?) {
        settlePromise {
            if let error = error {
                print("Portmone payment failed with error: \(error.localizedDescription)")
                self.promise.reject(withError: error)
                return
            }

            if let bill = bill {
                let result = PaymentResultMapper.fromBill(bill)
                print("Portmone payment successful: \(bill.billId ?? "no bill ID")")
                self.promise.resolve(withResult: result)
            } else {
                print("Portmone payment failed with no error or bill information")
                self.promise.reject(withError: HfPortmoneError.paymentGenericError.nsError)
            }
        }
    }

    func dismissedSDK() {
        settlePromise {
            print("Portmone SDK was dismissed")
            let result = PaymentResult(
                billId: nil,
                status: "dismissed",
                billAmount: 0,
                cardMask: nil,
                commissionAmount: 0,
                receiptUrl: nil,
                contractNumber: nil,
                payDate: nil,
                payeeName: nil,
                token: nil
            )
            self.promise.resolve(withResult: result)
        }
    }

    func canceledSDK() {
        settlePromise {
            print("Portmone payment was canceled by user")
            let result = PaymentResult(
                billId: nil,
                status: "canceled",
                billAmount: 0,
                cardMask: nil,
                commissionAmount: 0,
                receiptUrl: nil,
                contractNumber: nil,
                payDate: nil,
                payeeName: nil,
                token: nil
            )
            self.promise.resolve(withResult: result)
        }
    }

    // Handle timeout result (called from HybridHfPortmone)
    func handleTimeoutResult(_ result: PaymentResult) {
        settlePromise {
            print("Portmone payment timed out")
            self.promise.resolve(withResult: result)
        }
    }

    // Execute closure on main thread
    private func ensureMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}
