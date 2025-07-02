// ios/UIApplication+Extension.swift
import UIKit

extension UIApplication {
    // Thread-safe method to get root view controller
    static func safeGetRootViewController(completion: @escaping (UIViewController?) -> Void) {
        if Thread.isMainThread {
            // If already on main thread, return immediately
            completion(getRootViewController())
        } else {
            // Otherwise dispatch to main thread
            DispatchQueue.main.async {
                completion(getRootViewController())
            }
        }
    }
    
    // Private implementation that should only be called on main thread
    private static func getRootViewController() -> UIViewController? {
        // Must be on main thread to access UIApplication
        guard Thread.isMainThread else {
            print("ERROR: Attempt to access UIKit from background thread")
            return nil
        }
        
        var rootVC: UIViewController?
        
        // iOS 13+ window scene handling
        if #available(iOS 13.0, *) {
            // Get all connected scenes
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive,
                   let windowScene = scene as? UIWindowScene {
                    
                    // Find all visible windows first
                    let visibleWindows = windowScene.windows.filter { !$0.isHidden }
                    
                    // Try to find the key window first
                    let keyWindow = visibleWindows.first { $0.isKeyWindow } ?? visibleWindows.first
                    
                    if let controller = keyWindow?.rootViewController {
                        rootVC = controller
                        break
                    }
                }
            }
        }
        
        // Fallback for older iOS versions or if scene-based approach failed
        if rootVC == nil {
            // Try to find visible windows
            let visibleWindows = UIApplication.shared.windows.filter { !$0.isHidden }
            
            // First try to find the key window
            let keyWindow = visibleWindows.first { $0.isKeyWindow } ?? visibleWindows.first
            
            rootVC = keyWindow?.rootViewController
        }
        
        // Last resort fallback for older iOS versions
        if rootVC == nil {
            // For older iOS versions, try to find the key window directly
            #if swift(>=5.1)
            if #available(iOS 13.0, *) {} else {
                rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
            }
            #else
            rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
            #endif
        }
        
        guard let viewController = rootVC else {
            return nil
        }
        
        return findTopViewController(viewController)
    }
    
    // Find the topmost presented view controller
    private static func findTopViewController(_ viewController: UIViewController) -> UIViewController {
        // Log the traversal for debugging
        print("Traversing view controller hierarchy: \(type(of: viewController))")
        
        // Handle presented controllers - most important case
        if let presentedVC = viewController.presentedViewController {
            return findTopViewController(presentedVC)
        }
        
        // Handle different container controllers
        switch viewController {
        case let navController as UINavigationController:
            // For navigation controllers, use the visible view controller or top controller
            guard let visibleVC = navController.visibleViewController ?? navController.topViewController else {
                return navController
            }
            return findTopViewController(visibleVC)
            
        case let tabBarController as UITabBarController:
            // For tab controllers, use the selected view controller
            guard let selectedVC = tabBarController.selectedViewController else {
                return tabBarController
            }
            return findTopViewController(selectedVC)
            
        case let pageViewController as UIPageViewController:
            // For page view controllers, use the first view controller
            guard let firstVC = pageViewController.viewControllers?.first else {
                return pageViewController
            }
            return findTopViewController(firstVC)
            
        case let splitViewController as UISplitViewController:
            // For split view controllers (iPad), use the detail view controller or first controller
            if #available(iOS 14.0, *) {
                // iOS 14+ changed the SplitViewController API
                let targetVC: UIViewController?
                
                // Check if there's a selected view controller
                if splitViewController.viewControllers.count > 1 {
                    targetVC = splitViewController.viewControllers[1]
                } else if !splitViewController.viewControllers.isEmpty {
                    targetVC = splitViewController.viewControllers[0]
                } else {
                    targetVC = nil
                }
                
                guard let vc = targetVC else {
                    return splitViewController
                }
                return findTopViewController(vc)
            } else {
                // Legacy iOS versions
                if let detailVC = splitViewController.viewControllers.count > 1 ? 
                    splitViewController.viewControllers[1] : nil {
                    return findTopViewController(detailVC)
                } else if !splitViewController.viewControllers.isEmpty {
                    return findTopViewController(splitViewController.viewControllers[0])
                }
                return splitViewController
            }
            
        default:
            // Return the current view controller if it doesn't contain other controllers
            return viewController
        }
    }
    
    // Get key window property
    static var activeWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        } else {
            // For older iOS versions, use the windows array
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    // Get all visible windows
    static var visibleWindows: [UIWindow] {
        return UIApplication.shared.windows.filter { !$0.isHidden }
    }
    
    // Force resign first responder for any active text field
    static func forceResignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
