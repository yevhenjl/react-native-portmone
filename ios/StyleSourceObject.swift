// ios/StyleSourceObject.swift
import UIKit
import PortmoneSDKEcom

class StyleSourceObject: StyleSourceModel {
    
    private var styler: Styler
    
    init(styleOptions: Any? = nil) {
        // Ensure we're on the main thread for initialization
        assert(Thread.isMainThread || styleOptions == nil, "StyleSourceObject should be initialized on the main thread when using non-nil style options")
        
        self.styler = Styler(styleOptions: styleOptions)
        super.init()
    }
    
    // Thread-safe factory method
    static func create(with styleOptions: Any?) -> StyleSourceObject {
        if Thread.isMainThread {
            return StyleSourceObject(styleOptions: styleOptions)
        } else {
            // For thread safety, initialize with nil and update later
            let styleSource = StyleSourceObject(styleOptions: nil)
            
            // Schedule style update on main thread
            DispatchQueue.main.async {
                styleSource.updateStyles(with: styleOptions)
            }
            
            return styleSource
        }
    }
    
    // Method to update styles on main thread
    func updateStyles(with styleOptions: Any?) {
        if Thread.isMainThread {
            self.styler = Styler(styleOptions: styleOptions)
        } else {
            DispatchQueue.main.async {
                self.styler = Styler(styleOptions: styleOptions)
            }
        }
    }
    
    // Always ensure we're on the main thread when accessing UI properties
    private func ensureMainThread<T>(_ defaultValue: T, _ block: () -> T) -> T {
        if Thread.isMainThread {
            return block()
        } else {
            // Log warning about accessing UI methods from background thread
            print("WARNING: Accessing StyleSourceObject UI methods from background thread")
            return defaultValue
        }
    }
    
    override func titleFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 16)) { styler.cTitleFont }
    }
    
    override func titleColor() -> UIColor {
        return ensureMainThread(UIColor.black) { styler.cTitleColor }
    }
    
    override func titleBackgroundColor() -> UIColor {
        return ensureMainThread(UIColor.white) { styler.cTitleBackgroundColor }
    }
    
    override func headersFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 14)) { styler.cHeadersFont }
    }
    
    override func headersColor() -> UIColor {
        return ensureMainThread(UIColor.black) { styler.cHeadersColor }
    }
    
    override func headersBackgroundColor() -> UIColor {
        return ensureMainThread(UIColor.lightGray) { styler.cHeadersBackgroundColor }
    }
    
    override func placeholdersFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 16)) { styler.cPlaceholdersFont }
    }
    
    override func placeholdersColor() -> UIColor {
        return ensureMainThread(UIColor.gray) { styler.cPlaceholdersColor }
    }
    
    override func textsFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 16)) { styler.cTextsFont }
    }
    
    override func textsColor() -> UIColor {
        return ensureMainThread(UIColor.black) { styler.cTextsColor }
    }
    
    override func errorsFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 12)) { styler.cErrorsFont }
    }
    
    override func errorsColor() -> UIColor {
        return ensureMainThread(UIColor.red) { styler.cErrorsColor }
    }
    
    override func backgroundColor() -> UIColor {
        return ensureMainThread(UIColor.white) { styler.cBackgroundColor }
    }
    
    override func resultMessageFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 18)) { styler.cResultMessageFont }
    }
    
    override func resultMessageColor() -> UIColor {
        return ensureMainThread(UIColor.black) { styler.cResultMessageColor }
    }
    
    override func resultSaveReceiptColor() -> UIColor {
        return ensureMainThread(UIColor.black) { styler.cResultSaveReceiptColor }
    }
    
    override func infoTextsFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 14)) { styler.cInfoTextsFont }
    }
    
    override func infoTextsColor() -> UIColor {
        return ensureMainThread(UIColor.gray) { styler.cInfoTextsColor }
    }
    
    override func buttonTitleFont() -> UIFont {
        return ensureMainThread(UIFont.systemFont(ofSize: 18)) { styler.cButtonTitleFont }
    }
    
    override func buttonTitleColor() -> UIColor {
        return ensureMainThread(UIColor.white) { styler.cButtonTitleColor }
    }
    
    override func buttonColor() -> UIColor {
        return ensureMainThread(UIColor.systemBlue) { styler.cButtonColor }
    }
    
    override func buttonCornerRadius() -> CGFloat {
        return styler.cButtonCornerRadius
    }
    
    override func biometricButtonColor() -> UIColor {
        return ensureMainThread(UIColor.gray) { styler.cBiometricButtonColor }
    }
    
    override func successImage() -> UIImage? {
        return ensureMainThread(nil) { styler.cSuccessResultImage }
    }
    
    override func failureImage() -> UIImage? {
        return ensureMainThread(nil) { styler.cFailureResultImage }
    }
}
