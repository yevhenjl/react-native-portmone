// ios/Styler.swift
import UIKit

final class Styler {
    // Title styles
    var cTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    var cTitleColor = UIColor.black
    var cTitleBackgroundColor = UIColor.white
    
    // Headers styles
    var cHeadersFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    var cHeadersColor = UIColor.black
    var cHeadersBackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    
    // Placeholder styles
    var cPlaceholdersFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    var cPlaceholdersColor = UIColor.gray
    
    // Text styles
    var cTextsFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    var cTextsColor = UIColor.black
    
    // Error styles
    var cErrorsFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    var cErrorsColor = UIColor.red
    
    // Background styles
    var cBackgroundColor = UIColor.white
    
    // Result styles
    var cResultMessageFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    var cResultMessageColor = UIColor.black
    var cResultSaveReceiptColor = UIColor.black
    
    // Info text styles
    var cInfoTextsFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    var cInfoTextsColor = UIColor.gray
    
    // Button styles
    var cButtonTitleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    var cButtonTitleColor = UIColor.white
    var cButtonColor = UIColor.systemBlue
    var cButtonCornerRadius: CGFloat = 8
    var cBiometricButtonColor = UIColor.gray
    
    // Result images
    var cSuccessResultImage: UIImage?
    var cFailureResultImage: UIImage?
    
    // Initialize with default values
    init() {}
    
    // Initialize with custom values from JS
    // Use the Nitro-generated StyleOptions type
    init(styleOptions: Any?) {
        // Early return if no options provided
        guard let options = styleOptions as? StyleOptions else { return }
        
        // Apply custom styling if provided
        if let titleFontName = options.titleFontName {
            cTitleFont = HfPortmoneStyleHelper.fontFrom(fontName: titleFontName, size: 16) ?? cTitleFont
        }
        
        if let titleColor = options.titleColor {
            cTitleColor = HfPortmoneStyleHelper.colorFrom(hexString: titleColor) ?? cTitleColor
        }
        
        if let titleBackgroundColor = options.titleBackgroundColor {
            cTitleBackgroundColor = HfPortmoneStyleHelper.colorFrom(hexString: titleBackgroundColor) ?? cTitleBackgroundColor
        }
        
        if let headersFontName = options.headersFontName {
            cHeadersFont = HfPortmoneStyleHelper.fontFrom(fontName: headersFontName, size: 14) ?? cHeadersFont
        }
        
        if let headersColor = options.headersColor {
            cHeadersColor = HfPortmoneStyleHelper.colorFrom(hexString: headersColor) ?? cHeadersColor
        }
        
        if let headersBackgroundColor = options.headersBackgroundColor {
            cHeadersBackgroundColor = HfPortmoneStyleHelper.colorFrom(hexString: headersBackgroundColor) ?? cHeadersBackgroundColor
        }
        
        if let placeholdersFontName = options.placeholdersFontName {
            cPlaceholdersFont = HfPortmoneStyleHelper.fontFrom(fontName: placeholdersFontName, size: 16) ?? cPlaceholdersFont
        }
        
        if let placeholdersColor = options.placeholdersColor {
            cPlaceholdersColor = HfPortmoneStyleHelper.colorFrom(hexString: placeholdersColor) ?? cPlaceholdersColor
        }
        
        if let textsFontName = options.textsFontName {
            cTextsFont = HfPortmoneStyleHelper.fontFrom(fontName: textsFontName, size: 16) ?? cTextsFont
        }
        
        if let textsColor = options.textsColor {
            cTextsColor = HfPortmoneStyleHelper.colorFrom(hexString: textsColor) ?? cTextsColor
        }
        
        if let errorsFontName = options.errorsFontName {
            cErrorsFont = HfPortmoneStyleHelper.fontFrom(fontName: errorsFontName, size: 12) ?? cErrorsFont
        }
        
        if let errorsColor = options.errorsColor {
            cErrorsColor = HfPortmoneStyleHelper.colorFrom(hexString: errorsColor) ?? cErrorsColor
        }
        
        if let backgroundColor = options.backgroundColor {
            cBackgroundColor = HfPortmoneStyleHelper.colorFrom(hexString: backgroundColor) ?? cBackgroundColor
        }
        
        if let resultMessageFontName = options.resultMessageFontName {
            cResultMessageFont = HfPortmoneStyleHelper.fontFrom(fontName: resultMessageFontName, size: 18) ?? cResultMessageFont
        }
        
        if let resultMessageColor = options.resultMessageColor {
            cResultMessageColor = HfPortmoneStyleHelper.colorFrom(hexString: resultMessageColor) ?? cResultMessageColor
        }
        
        if let resultSaveReceiptColor = options.resultSaveReceiptColor {
            cResultSaveReceiptColor = HfPortmoneStyleHelper.colorFrom(hexString: resultSaveReceiptColor) ?? cResultSaveReceiptColor
        }
        
        if let infoTextsFont = options.infoTextsFont {
            cInfoTextsFont = HfPortmoneStyleHelper.fontFrom(fontName: infoTextsFont, size: 14) ?? cInfoTextsFont
        }
        
        if let infoTextsColor = options.infoTextsColor {
            cInfoTextsColor = HfPortmoneStyleHelper.colorFrom(hexString: infoTextsColor) ?? cInfoTextsColor
        }
        
        if let buttonTitleFontName = options.buttonTitleFontName {
            cButtonTitleFont = HfPortmoneStyleHelper.fontFrom(fontName: buttonTitleFontName, size: 18) ?? cButtonTitleFont
        }
        
        if let buttonTitleColor = options.buttonTitleColor {
            cButtonTitleColor = HfPortmoneStyleHelper.colorFrom(hexString: buttonTitleColor) ?? cButtonTitleColor
        }
        
        if let buttonColor = options.buttonColor {
            cButtonColor = HfPortmoneStyleHelper.colorFrom(hexString: buttonColor) ?? cButtonColor
        }
        
        if let buttonCornerRadius = options.buttonCornerRadius {
            cButtonCornerRadius = CGFloat(buttonCornerRadius)
        }
        
        if let biometricButtonColor = options.biometricButtonColor {
            cBiometricButtonColor = HfPortmoneStyleHelper.colorFrom(hexString: biometricButtonColor) ?? cBiometricButtonColor
        }
    }
}
