///
/// PaymentFlowType.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#pragma once

#if __has_include(<NitroModules/JSIConverter.hpp>)
#include <NitroModules/JSIConverter.hpp>
#else
#error NitroModules cannot be found! Are you sure you installed NitroModules properly?
#endif
#if __has_include(<NitroModules/NitroDefines.hpp>)
#include <NitroModules/NitroDefines.hpp>
#else
#error NitroModules cannot be found! Are you sure you installed NitroModules properly?
#endif



#include <optional>

namespace margelo::nitro::hfportmone {

  /**
   * A struct which can be represented as a JavaScript object (PaymentFlowType).
   */
  struct PaymentFlowType {
  public:
    std::optional<bool> payWithCard     SWIFT_PRIVATE;
    std::optional<bool> payWithAppleGPay     SWIFT_PRIVATE;
    std::optional<bool> withoutCVV     SWIFT_PRIVATE;

  public:
    PaymentFlowType() = default;
    explicit PaymentFlowType(std::optional<bool> payWithCard, std::optional<bool> payWithAppleGPay, std::optional<bool> withoutCVV): payWithCard(payWithCard), payWithAppleGPay(payWithAppleGPay), withoutCVV(withoutCVV) {}
  };

} // namespace margelo::nitro::hfportmone

namespace margelo::nitro {

  using namespace margelo::nitro::hfportmone;

  // C++ PaymentFlowType <> JS PaymentFlowType (object)
  template <>
  struct JSIConverter<PaymentFlowType> final {
    static inline PaymentFlowType fromJSI(jsi::Runtime& runtime, const jsi::Value& arg) {
      jsi::Object obj = arg.asObject(runtime);
      return PaymentFlowType(
        JSIConverter<std::optional<bool>>::fromJSI(runtime, obj.getProperty(runtime, "payWithCard")),
        JSIConverter<std::optional<bool>>::fromJSI(runtime, obj.getProperty(runtime, "payWithAppleGPay")),
        JSIConverter<std::optional<bool>>::fromJSI(runtime, obj.getProperty(runtime, "withoutCVV"))
      );
    }
    static inline jsi::Value toJSI(jsi::Runtime& runtime, const PaymentFlowType& arg) {
      jsi::Object obj(runtime);
      obj.setProperty(runtime, "payWithCard", JSIConverter<std::optional<bool>>::toJSI(runtime, arg.payWithCard));
      obj.setProperty(runtime, "payWithAppleGPay", JSIConverter<std::optional<bool>>::toJSI(runtime, arg.payWithAppleGPay));
      obj.setProperty(runtime, "withoutCVV", JSIConverter<std::optional<bool>>::toJSI(runtime, arg.withoutCVV));
      return obj;
    }
    static inline bool canConvert(jsi::Runtime& runtime, const jsi::Value& value) {
      if (!value.isObject()) {
        return false;
      }
      jsi::Object obj = value.getObject(runtime);
      if (!JSIConverter<std::optional<bool>>::canConvert(runtime, obj.getProperty(runtime, "payWithCard"))) return false;
      if (!JSIConverter<std::optional<bool>>::canConvert(runtime, obj.getProperty(runtime, "payWithAppleGPay"))) return false;
      if (!JSIConverter<std::optional<bool>>::canConvert(runtime, obj.getProperty(runtime, "withoutCVV"))) return false;
      return true;
    }
  };

} // namespace margelo::nitro
