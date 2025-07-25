///
/// PaymentResult.kt
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

package com.margelo.nitro.hfportmone

import androidx.annotation.Keep
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.core.*

/**
 * Represents the JavaScript object/struct "PaymentResult".
 */
@DoNotStrip
@Keep
data class PaymentResult
  @DoNotStrip
  @Keep
  constructor(
    val billId: String?,
    val status: String,
    val billAmount: Double,
    val cardMask: String?,
    val commissionAmount: Double,
    val receiptUrl: String?,
    val contractNumber: String?,
    val payDate: Double?,
    val payeeName: String?,
    val token: String?
  ) {
  /* main constructor */
}
