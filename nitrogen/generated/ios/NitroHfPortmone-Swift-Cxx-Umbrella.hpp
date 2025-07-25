///
/// NitroHfPortmone-Swift-Cxx-Umbrella.hpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#pragma once

// Forward declarations of C++ defined types
// Forward declaration of `HybridHfPortmoneSpec` to properly resolve imports.
namespace margelo::nitro::hfportmone { class HybridHfPortmoneSpec; }
// Forward declaration of `Language` to properly resolve imports.
namespace margelo::nitro::hfportmone { enum class Language; }
// Forward declaration of `PaymentFlowType` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct PaymentFlowType; }
// Forward declaration of `PaymentParams` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct PaymentParams; }
// Forward declaration of `PaymentResult` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct PaymentResult; }
// Forward declaration of `PreauthParams` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct PreauthParams; }
// Forward declaration of `StyleOptions` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct StyleOptions; }
// Forward declaration of `TokenPaymentParams` to properly resolve imports.
namespace margelo::nitro::hfportmone { struct TokenPaymentParams; }

// Include C++ defined types
#include "HybridHfPortmoneSpec.hpp"
#include "Language.hpp"
#include "PaymentFlowType.hpp"
#include "PaymentParams.hpp"
#include "PaymentResult.hpp"
#include "PreauthParams.hpp"
#include "StyleOptions.hpp"
#include "TokenPaymentParams.hpp"
#include <NitroModules/Promise.hpp>
#include <NitroModules/Result.hpp>
#include <exception>
#include <memory>
#include <optional>
#include <string>

// C++ helpers for Swift
#include "NitroHfPortmone-Swift-Cxx-Bridge.hpp"

// Common C++ types used in Swift
#include <NitroModules/ArrayBufferHolder.hpp>
#include <NitroModules/AnyMapHolder.hpp>
#include <NitroModules/RuntimeError.hpp>

// Forward declarations of Swift defined types
// Forward declaration of `HybridHfPortmoneSpec_cxx` to properly resolve imports.
namespace NitroHfPortmone { class HybridHfPortmoneSpec_cxx; }

// Include Swift defined types
#if __has_include("NitroHfPortmone-Swift.h")
// This header is generated by Xcode/Swift on every app build.
// If it cannot be found, make sure the Swift module's name (= podspec name) is actually "NitroHfPortmone".
#include "NitroHfPortmone-Swift.h"
// Same as above, but used when building with frameworks (`use_frameworks`)
#elif __has_include(<NitroHfPortmone/NitroHfPortmone-Swift.h>)
#include <NitroHfPortmone/NitroHfPortmone-Swift.h>
#else
#error NitroHfPortmone's autogenerated Swift header cannot be found! Make sure the Swift module's name (= podspec name) is actually "NitroHfPortmone", and try building the app first.
#endif
