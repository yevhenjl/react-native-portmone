///
/// StyleOptions.swift
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

import NitroModules

/**
 * Represents an instance of `StyleOptions`, backed by a C++ struct.
 */
public typealias StyleOptions = margelo.nitro.hfportmone.StyleOptions

public extension StyleOptions {
  private typealias bridge = margelo.nitro.hfportmone.bridge.swift

  /**
   * Create a new instance of `StyleOptions`.
   */
  init(titleFontName: String?, titleColor: String?, titleBackgroundColor: String?, headersFontName: String?, headersColor: String?, headersBackgroundColor: String?, placeholdersFontName: String?, placeholdersColor: String?, textsFontName: String?, textsColor: String?, errorsFontName: String?, errorsColor: String?, backgroundColor: String?, resultMessageFontName: String?, resultMessageColor: String?, resultSaveReceiptColor: String?, infoTextsFont: String?, infoTextsColor: String?, buttonTitleFontName: String?, buttonTitleColor: String?, buttonColor: String?, buttonCornerRadius: Double?, biometricButtonColor: String?, successResultImage: String?, failureResultImage: String?) {
    self.init({ () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = titleFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = titleColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = titleBackgroundColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = headersFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = headersColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = headersBackgroundColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = placeholdersFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = placeholdersColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = textsFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = textsColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = errorsFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = errorsColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = backgroundColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = resultMessageFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = resultMessageColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = resultSaveReceiptColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = infoTextsFont {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = infoTextsColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = buttonTitleFontName {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = buttonTitleColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = buttonColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_double_ in
      if let __unwrappedValue = buttonCornerRadius {
        return bridge.create_std__optional_double_(__unwrappedValue)
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = biometricButtonColor {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = successResultImage {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }(), { () -> bridge.std__optional_std__string_ in
      if let __unwrappedValue = failureResultImage {
        return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
      } else {
        return .init()
      }
    }())
  }

  var titleFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__titleFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__titleFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var titleColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__titleColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__titleColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var titleBackgroundColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__titleBackgroundColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__titleBackgroundColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var headersFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__headersFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__headersFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var headersColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__headersColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__headersColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var headersBackgroundColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__headersBackgroundColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__headersBackgroundColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var placeholdersFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__placeholdersFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__placeholdersFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var placeholdersColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__placeholdersColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__placeholdersColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var textsFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__textsFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__textsFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var textsColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__textsColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__textsColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var errorsFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__errorsFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__errorsFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var errorsColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__errorsColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__errorsColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var backgroundColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__backgroundColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__backgroundColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var resultMessageFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__resultMessageFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__resultMessageFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var resultMessageColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__resultMessageColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__resultMessageColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var resultSaveReceiptColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__resultSaveReceiptColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__resultSaveReceiptColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var infoTextsFont: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__infoTextsFont.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__infoTextsFont = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var infoTextsColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__infoTextsColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__infoTextsColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var buttonTitleFontName: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__buttonTitleFontName.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__buttonTitleFontName = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var buttonTitleColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__buttonTitleColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__buttonTitleColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var buttonColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__buttonColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__buttonColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var buttonCornerRadius: Double? {
    @inline(__always)
    get {
      return self.__buttonCornerRadius.value
    }
    @inline(__always)
    set {
      self.__buttonCornerRadius = { () -> bridge.std__optional_double_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_double_(__unwrappedValue)
        } else {
          return .init()
        }
      }()
    }
  }
  
  var biometricButtonColor: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__biometricButtonColor.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__biometricButtonColor = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var successResultImage: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__successResultImage.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__successResultImage = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
  
  var failureResultImage: String? {
    @inline(__always)
    get {
      return { () -> String? in
        if let __unwrapped = self.__failureResultImage.value {
          return String(__unwrapped)
        } else {
          return nil
        }
      }()
    }
    @inline(__always)
    set {
      self.__failureResultImage = { () -> bridge.std__optional_std__string_ in
        if let __unwrappedValue = newValue {
          return bridge.create_std__optional_std__string_(std.string(__unwrappedValue))
        } else {
          return .init()
        }
      }()
    }
  }
}
