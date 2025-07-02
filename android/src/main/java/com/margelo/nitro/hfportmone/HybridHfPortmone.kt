// HybridHfPortmone.kt
package com.margelo.nitro.hfportmone

import android.app.Activity
import android.graphics.Color
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.annotation.Keep
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.core.Promise
import com.portmone.ecomsdk.PortmoneSDK
import com.portmone.ecomsdk.data.Bill
import com.portmone.ecomsdk.data.CardPaymentParams
import com.portmone.ecomsdk.data.SaveCardParams
import com.portmone.ecomsdk.data.TokenPaymentParams as PortmoneTokenPaymentParams
import com.portmone.ecomsdk.data.contract_params.CardPaymentContractParams
import com.portmone.ecomsdk.data.contract_params.TokenPaymentContractParams
import com.portmone.ecomsdk.data.style.AppStyle
import com.portmone.ecomsdk.data.style.BlockTitleTextStyle
import com.portmone.ecomsdk.data.style.ButtonStyle
import com.portmone.ecomsdk.data.style.DialogStyle
import com.portmone.ecomsdk.data.style.EditTextStyle
import com.portmone.ecomsdk.data.style.TextStyle
import com.portmone.ecomsdk.ui.card.CardPaymentContract
import com.portmone.ecomsdk.ui.savecard.PreauthCardContract
import com.portmone.ecomsdk.ui.token.payment.TokenPaymentContract
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

private const val TAG = "HybridHfPortmone"

@DoNotStrip
@Keep
class HybridHfPortmone : HybridHfPortmoneSpec() {
    // Local state
    private var timeoutMs: Long = 3600000 // Default 1 hour timeout
    private var returnToDetailsDisabled: Boolean = false
    private var appStyle: AppStyle? = null
    private var currentLanguage: String? = null

    // Track ongoing payment promises by operation ID
    private val promiseMap = ConcurrentHashMap<Int, Promise<PaymentResult>>()
    private val operationCounter = AtomicInteger(0)

    companion object {
        // Static instance for result callbacks
        private var instance: HybridHfPortmone? = null

        // Convert Portmone Bill to our PaymentResult
        private fun billToPaymentResult(bill: Bill): PaymentResult {
            return PaymentResult(
                billId = bill.billId,
                status = bill.status,                    // Non-nullable, removed Elvis operator
                billAmount = bill.billAmount,            // Non-nullable, removed Elvis operator
                cardMask = bill.cardMask,
                commissionAmount = bill.commissionAmount,  // Non-nullable, removed Elvis operator
                receiptUrl = bill.receiptUrl,
                contractNumber = bill.contractNumber,
                payDate = bill.payDate.toDouble(),     // Non-nullable, removed safe call
                payeeName = bill.payeeName,
                token = bill.token
            )
        }

        // Get current activity using our helper
        fun getCurrentActivity(): Activity? {
            return ReactActivityHelper.getCurrentActivity()
        }
    }

    init {
        // Store instance for callback access
        instance = this
    }

    override fun initialize(styleOptions: StyleOptions?, language: Language?) {
        try {
            // Configure language
            if (language != null) {
                val languageCode = when (language) {
                    Language.UKRAINIAN -> "uk"
                    Language.ENGLISH -> "en"
                }
                try {
                    val method = PortmoneSDK::class.java.getDeclaredMethod(
                        "setLanguage",
                        String::class.java
                    )
                    method.invoke(null, languageCode)
                    currentLanguage = languageCode
                } catch (e: Exception) {
                    Log.e(TAG, "Error setting language: $languageCode", e)
                }
            }

            // Configure app style if provided
            if (styleOptions != null) {
                val appStyle = AppStyle()

                // Background and toolbar
                styleOptions.backgroundColor?.let {
                    appStyle.background = parseColor(it)
                }

                styleOptions.titleBackgroundColor?.let {
                    appStyle.toolbarColor = parseColor(it)
                }

                // Title style
                val titleStyle = TextStyle()
                styleOptions.titleColor?.let { titleStyle.textColor = parseColor(it) }
                styleOptions.titleFontName?.let {
                    try {
                        // Handle font setting - use reflection to be compatible with different SDK versions
                        val fontId = it.toIntOrNull() ?: 0
                        // Try to set font using reflection
                        try {
                            val method = TextStyle::class.java.getDeclaredMethod("setTextFont", Int::class.java)
                            method.invoke(titleStyle, fontId)
                        } catch (e: Exception) {
                            Log.e(TAG, "Could not set title font: ${e.message}. Font setting not implemented in this SDK version.")
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Error setting text font", e)
                    }
                }
                appStyle.titleTextStyle = titleStyle

                // Description style
                val descriptionStyle = TextStyle()
                styleOptions.resultMessageColor?.let { descriptionStyle.textColor = parseColor(it) }
                styleOptions.resultMessageFontName?.let {
                    try {
                        // Handle font setting - use reflection to be compatible with different SDK versions
                        val fontId = it.toIntOrNull() ?: 0
                        // Try to set font using reflection
                        try {
                            val method = TextStyle::class.java.getDeclaredMethod("setTextFont", Int::class.java)
                            method.invoke(descriptionStyle, fontId)
                        } catch (e: Exception) {
                            Log.e(TAG, "Could not set description font: ${e.message}. Font setting not implemented in this SDK version.")
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Error setting description font", e)
                    }
                }
                appStyle.descriptionTextStyle = descriptionStyle

                // Button style
                val buttonStyle = ButtonStyle()
                styleOptions.buttonColor?.let { buttonStyle.backgroundColor = parseColor(it) }
                styleOptions.buttonTitleColor?.let { buttonStyle.textColor = parseColor(it) }
                styleOptions.buttonCornerRadius?.let { buttonStyle.cornerRadius = it.toFloat() }
                appStyle.buttonStyle = buttonStyle

                // Input field style
                val editTextStyle = EditTextStyle()
                styleOptions.textsColor?.let { editTextStyle.textColor = parseColor(it) }
                styleOptions.placeholdersColor?.let { editTextStyle.hintTextColor = parseColor(it) }
                styleOptions.errorsColor?.let { editTextStyle.errorTextColor = parseColor(it) }
                appStyle.editTextStyle = editTextStyle

                // Headers style
                val blockTitleStyle = BlockTitleTextStyle()
                styleOptions.headersColor?.let { blockTitleStyle.textColor = parseColor(it) }
                styleOptions.headersBackgroundColor?.let { blockTitleStyle.backgroundColor = parseColor(it) }
                appStyle.blockTitleTextStyle = blockTitleStyle

                // Additional info style
                val infoTextStyle = TextStyle()
                styleOptions.infoTextsColor?.let { infoTextStyle.textColor = parseColor(it) }
                appStyle.additionalInfoTextStyle = infoTextStyle

                // Set receipt download button style
                val receiptStyle = TextStyle()
                styleOptions.resultSaveReceiptColor?.let { receiptStyle.textColor = parseColor(it) }
                appStyle.paymentSuccessDownload = receiptStyle

                // Biometric button style
                val biometricButtonStyle = TextStyle()
                styleOptions.biometricButtonColor?.let { biometricButtonStyle.textColor = parseColor(it) }
                appStyle.fingerprintButton = biometricButtonStyle

                // Dialog style
                val dialogStyle = DialogStyle()
                val dialogTitleStyle = TextStyle()
                val dialogButtonStyle = TextStyle()
                styleOptions.titleColor?.let { dialogTitleStyle.textColor = parseColor(it) }
                styleOptions.buttonTitleColor?.let { dialogButtonStyle.textColor = parseColor(it) }
                dialogStyle.title = dialogTitleStyle
                dialogStyle.button = dialogButtonStyle
                appStyle.dialogStyle = dialogStyle

                // Success/failure images (if provided)
                styleOptions.successResultImage?.toIntOrNull()?.let {
                    appStyle.iconSuccess = it
                }
                styleOptions.failureResultImage?.toIntOrNull()?.let {
                    appStyle.iconError = it
                }

                // Apply the style - comment out as requested
                // PortmoneSDK.setAppStyle(appStyle)
                Log.i(TAG, "PortmoneSDK.setAppStyle(appStyle) should be used here")

                // Store for later use
                this.appStyle = appStyle
            }

            // Configure standard result flow for consistency
            try {
                val method = PortmoneSDK::class.java.getDeclaredMethod(
                    "setStandartResultFlow",
                    Boolean::class.java
                )
                method.invoke(null, true)
            } catch (e: Exception) {
                Log.e(TAG, "Error setting standard result flow", e)
            }

            Log.i(TAG, "Portmone SDK initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing Portmone SDK", e)
        }
    }

    override fun setTimeout(timeoutMs: Double) {
        this.timeoutMs = timeoutMs.toLong()
        Log.i(TAG, "Payment timeout set to $timeoutMs ms")
    }

    override fun setReturnToDetailsDisabled(disabled: Boolean) {
        this.returnToDetailsDisabled = disabled
        Log.i(TAG, "Return to details disabled: $disabled")
    }

    override fun payByCard(params: PaymentParams, showReceiptScreen: Boolean?): Promise<PaymentResult> {
        return Promise.async {
            try {
                val activity = ReactActivityHelper.getAppCompatActivity()
                    ?: throw Exception("Could not get current activity")

                // Generate unique operation ID to track this promise
                val operationId = operationCounter.incrementAndGet()

                // Create CardPaymentParams from our params
                val cardPaymentParams = convertToCardPaymentParams(params)

                // Create contract params with receipt and return-to-details settings
                val contractParams = CardPaymentContractParams(
                    cardPaymentParams,
                    showReceiptScreen ?: true,
                    !returnToDetailsDisabled
                )

                // Create promise to be resolved when payment completes
                val promise = Promise<PaymentResult>()
                promiseMap[operationId] = promise

                // Set up timeout if configured
                if (timeoutMs > 0) {
                    val timeoutRunnable = Runnable {
                        if (promiseMap.containsKey(operationId)) {
                            Log.i(TAG, "TIMEOUT: Payment operation timed out after $timeoutMs ms")
                            val timeoutResult = PaymentResult(
                                billId = null,
                                status = "TIMEOUT",
                                billAmount = 0.0,
                                cardMask = null,
                                commissionAmount = 0.0,
                                receiptUrl = null,
                                contractNumber = null,
                                payDate = null,
                                payeeName = null,
                                token = null
                            )
                            promiseMap[operationId]?.resolve(timeoutResult)
                            promiseMap.remove(operationId)
                            // Force close the Payment Activity using finishAndRemoveTask()
                            activity.finishAndRemoveTask()
                        }
                    }
                    android.os.Handler(android.os.Looper.getMainLooper())
                        .postDelayed(timeoutRunnable, timeoutMs)
                }

                // Register result launcher BEFORE runOnUiThread
                val resultLauncher = registerCardPaymentLauncher(activity, operationId)

                // Launch the payment activity on the UI thread
                activity.runOnUiThread {
                    try {
                        resultLauncher.launch(contractParams)
                    } catch (e: Exception) {
                        promiseMap.remove(operationId)
                        promise.reject(e)
                    }
                }

                // Return the result from promise when resolved
                return@async promise.await()
            } catch (e: Exception) {
                Log.e(TAG, "Error in payByCard", e)
                throw e
            }
        }
    }


    override fun payByToken(
        payParams: PaymentParams,
        tokenParams: TokenPaymentParams,
        showReceiptScreen: Boolean?
    ): Promise<PaymentResult> {
        return Promise.async {
            try {
                val activity = ReactActivityHelper.getAppCompatActivity()
                    ?: throw Exception("Could not get current activity")

                // Generate unique operation ID to track this promise
                val operationId = operationCounter.incrementAndGet()

                // Create TokenPaymentParams from our params
                val tokenPaymentParams = convertToTokenPaymentParams(payParams, tokenParams)

                // Create contract params with receipt and return to details settings
                val contractParams = TokenPaymentContractParams(
                    tokenPaymentParams,
                    showReceiptScreen ?: true,
                    !returnToDetailsDisabled
                )

                // Create promise to be resolved when payment completes
                val promise = Promise<PaymentResult>()
                promiseMap[operationId] = promise

                // Set up timeout if configured
                if (timeoutMs > 0) {
                    val timeoutRunnable = Runnable {
                        // Only timeout if the promise is still in the map (operation not completed)
                        if (promiseMap.containsKey(operationId)) {
                            Log.i(TAG, "Token payment operation timed out after $timeoutMs ms")
                            val timeoutResult = PaymentResult(
                                billId = null,
                                status = "TIMEOUT",
                                billAmount = 0.0,
                                cardMask = null,
                                commissionAmount = 0.0,
                                receiptUrl = null,
                                contractNumber = null,
                                payDate = null,
                                payeeName = null,
                                token = null
                            )
                            promiseMap[operationId]?.resolve(timeoutResult)
                            promiseMap.remove(operationId)
                        }
                    }

                    // Schedule timeout
                    android.os.Handler(android.os.Looper.getMainLooper())
                        .postDelayed(timeoutRunnable, timeoutMs)
                }

                // Register result launcher BEFORE runOnUiThread
                val resultLauncher = registerTokenPaymentLauncher(activity, operationId)

                // Launch the payment activity on the UI thread
                activity.runOnUiThread {
                    try {
                        // Launch the payment activity
                        resultLauncher.launch(contractParams)
                    } catch (e: Exception) {
                        // Handle any errors during launch
                        promiseMap.remove(operationId)
                        promise.reject(e)
                    }
                }

                // Return result from promise when resolved
                return@async promise.await()
            } catch (e: Exception) {
                Log.e(TAG, "Error in payByToken", e)
                throw e
            }
        }
    }

    override fun saveCard(params: PreauthParams): Promise<PaymentResult> {
        return Promise.async {
            try {
                val activity = ReactActivityHelper.getAppCompatActivity()
                    ?: throw Exception("Could not get current activity")

                // Generate unique operation ID to track this promise
                val operationId = operationCounter.incrementAndGet()

                // Create SaveCardParams from our params
                val saveCardParams = SaveCardParams(
                    params.payeeId,
                    params.description,
                    params.billNumber ?: "SAVE${System.currentTimeMillis()}"
                )

                // Create promise to be resolved when card saving completes
                val promise = Promise<PaymentResult>()
                promiseMap[operationId] = promise

                // Set up timeout if configured
                if (timeoutMs > 0) {
                    val timeoutRunnable = Runnable {
                        // Only timeout if the promise is still in the map (operation not completed)
                        if (promiseMap.containsKey(operationId)) {
                            Log.i(TAG, "Card saving operation timed out after $timeoutMs ms")
                            val timeoutResult = PaymentResult(
                                billId = null,
                                status = "TIMEOUT",
                                billAmount = 0.0,
                                cardMask = null,
                                commissionAmount = 0.0,
                                receiptUrl = null,
                                contractNumber = null,
                                payDate = null,
                                payeeName = null,
                                token = null
                            )
                            promiseMap[operationId]?.resolve(timeoutResult)
                            promiseMap.remove(operationId)
                            // Force close the Payment Activity using finishAndRemoveTask()
                            activity.finishAndRemoveTask()
                        }
                    }

                    // Schedule timeout
                    android.os.Handler(android.os.Looper.getMainLooper())
                        .postDelayed(timeoutRunnable, timeoutMs)
                }

                // Register result launcher BEFORE runOnUiThread
                val resultLauncher = registerSaveCardLauncher(activity, operationId)

                // Launch the card saving activity on the UI thread
                activity.runOnUiThread {
                    try {
                        // Launch the card saving activity
                        resultLauncher.launch(saveCardParams)
                    } catch (e: Exception) {
                        // Handle any errors during launch
                        promiseMap.remove(operationId)
                        promise.reject(e)
                    }
                }

                // Return result from promise when resolved
                return@async promise.await()
            } catch (e: Exception) {
                Log.e(TAG, "Error in saveCard", e)
                throw e
            }
        }
    }

    // Helper methods
    private fun registerCardPaymentLauncher(
        activity: AppCompatActivity,
        operationId: Int
    ): ActivityResultLauncher<CardPaymentContractParams> {
        val key = "card_payment_launcher_$operationId"
        return activity.activityResultRegistry.register(key, CardPaymentContract()) { result ->
            result.handleResult(
                { successResult ->
                    val paymentResult = billToPaymentResult(successResult.bill)
                    promiseMap[operationId]?.resolve(paymentResult)
                    promiseMap.remove(operationId)
                },
                { failureResult ->
                    val error = Exception("Payment failed: ${failureResult.message} (code: ${failureResult.code})")
                    promiseMap[operationId]?.reject(error)
                    promiseMap.remove(operationId)
                },
                {
                    val cancelResult = PaymentResult(
                        billId = null,
                        status = "CANCELED",
                        billAmount = 0.0,
                        cardMask = null,
                        commissionAmount = 0.0,
                        receiptUrl = null,
                        contractNumber = null,
                        payDate = null,
                        payeeName = null,
                        token = null
                    )
                    promiseMap[operationId]?.resolve(cancelResult)
                    promiseMap.remove(operationId)
                }
            )
        }
    }


    private fun registerTokenPaymentLauncher(
        activity: AppCompatActivity,
        operationId: Int
    ): ActivityResultLauncher<TokenPaymentContractParams> {
        val key = "token_payment_launcher_$operationId"
        return activity.activityResultRegistry.register(key, TokenPaymentContract()) { result ->
            result.handleResult(
                { successResult ->
                    // Handle successful payment
                    val paymentResult = billToPaymentResult(successResult.bill)
                    promiseMap[operationId]?.resolve(paymentResult)
                    promiseMap.remove(operationId)
                },
                { failureResult ->
                    // Handle payment failure
                    val error = Exception("Payment failed: ${failureResult.message} (code: ${failureResult.code})")
                    promiseMap[operationId]?.reject(error)
                    promiseMap.remove(operationId)
                },
                {
                    // Handle payment cancellation
                    val cancelResult = PaymentResult(
                        billId = null,
                        status = "CANCELED",
                        billAmount = 0.0,
                        cardMask = null,
                        commissionAmount = 0.0,
                        receiptUrl = null,
                        contractNumber = null,
                        payDate = null,
                        payeeName = null,
                        token = null
                    )
                    promiseMap[operationId]?.resolve(cancelResult)
                    promiseMap.remove(operationId)
                }
            )
        }
    }

    private fun registerSaveCardLauncher(
        activity: AppCompatActivity,
        operationId: Int
    ): ActivityResultLauncher<SaveCardParams> {
        val key = "save_card_launcher_$operationId"
        return activity.activityResultRegistry.register(key, PreauthCardContract()) { result ->
            result.handleResult(
                { successResult ->
                    // Handle successful card saving
                    val paymentResult = billToPaymentResult(successResult.bill)
                    promiseMap[operationId]?.resolve(paymentResult)
                    promiseMap.remove(operationId)
                },
                { failureResult ->
                    // Handle card saving failure
                    val error = Exception("Card saving failed: ${failureResult.message} (code: ${failureResult.code})")
                    promiseMap[operationId]?.reject(error)
                    promiseMap.remove(operationId)
                },
                {
                    // Handle card saving cancellation
                    val cancelResult = PaymentResult(
                        billId = null,
                        status = "CANCELED",
                        billAmount = 0.0,
                        cardMask = null,
                        commissionAmount = 0.0,
                        receiptUrl = null,
                        contractNumber = null,
                        payDate = null,
                        payeeName = null,
                        token = null
                    )
                    promiseMap[operationId]?.resolve(cancelResult)
                    promiseMap.remove(operationId)
                }
            )
        }
    }

    private fun convertToCardPaymentParams(params: PaymentParams): CardPaymentParams {
        // Determine if Google Pay is enabled and we should pass Google Pay options
        val useOnlyGooglePay = params.paymentFlowType?.payWithAppleGPay == true

        // Get email from params if available
        val email = null // Not exposed in our API, could add in future version

        // Check if we should create a Google Pay enabled param object
        return if (useOnlyGooglePay) {
            // Configure amount without CVV confirmation if provided
            if (params.billAmountWcvv != null && params.billAmountWcvv > 0.0) {
                // Use the PortmoneSDK method to set amount without CVV confirmation
                try {
                    val method = PortmoneSDK::class.java.getDeclaredMethod(
                        "setBillAmountWithoutCvvConfirmation",
                        Double::class.java
                    )
                    method.invoke(null, params.billAmountWcvv)
                } catch (e: Exception) {
                    Log.e(TAG, "Error setting bill amount without CVV confirmation", e)
                }
            }

            CardPaymentParams(
                params.payeeId,
                params.billNumber ?: "",
                "", // shopBillId (optional, not exposed in our API)
                params.preauthFlag ?: false,
                params.billCurrency ?: "UAH",
                params.attribute1 ?: "",
                params.attribute2 ?: "",
                params.attribute3 ?: "",
                params.attribute4 ?: "",
                params.attribute5 ?: "",
                params.billAmount,
                params.description ?: "",
                true, // onlyGooglePay - Only use Google Pay if explicitly requested
                false, // testEnvironment - Set to false for production
                email,
                false // privatPayEnabled - Not enabled by default
            )
        } else {
            // Configure amount without CVV confirmation if provided
            if (params.billAmountWcvv != null && params.billAmountWcvv > 0.0) {
                // Use the PortmoneSDK method to set amount without CVV confirmation
                try {
                    val method = PortmoneSDK::class.java.getDeclaredMethod(
                        "setBillAmountWithoutCvvConfirmation",
                        Double::class.java
                    )
                    method.invoke(null, params.billAmountWcvv)
                } catch (e: Exception) {
                    Log.e(TAG, "Error setting bill amount without CVV confirmation", e)
                }
            }

            // Standard payment params without Google Pay
            CardPaymentParams(
                params.payeeId,
                params.billNumber ?: "",
                "", // shopBillId (optional, not exposed in our API)
                params.preauthFlag ?: false,
                params.billCurrency ?: "UAH",
                params.attribute1 ?: "",
                params.attribute2 ?: "",
                params.attribute3 ?: "",
                params.attribute4 ?: "",
                params.attribute5 ?: "",
                params.billAmount,
                params.description ?: "",
                false, // onlyGooglePay - Only use Google Pay if explicitly requested
                false, // testEnvironment - Set to false for production
                email,
                false // privatPayEnabled - Not enabled by default
            )
        }
    }

    private fun convertToTokenPaymentParams(
        payParams: PaymentParams,
        tokenParams: TokenPaymentParams
    ): PortmoneTokenPaymentParams {
        // Check if we need to set the amount without CVV confirmation
        if (payParams.billAmountWcvv != null && payParams.billAmountWcvv > 0.0) {
            // Use reflection to call the method
            try {
                val method = PortmoneSDK::class.java.getDeclaredMethod(
                    "setBillAmountWithoutCvvConfirmation",
                    Double::class.java
                )
                method.invoke(null, payParams.billAmountWcvv)
            } catch (e: Exception) {
                Log.e(TAG, "Error setting bill amount without CVV confirmation", e)
            }
        } else if (payParams.paymentFlowType?.withoutCVV == true) {
            // If withoutCVV is explicitly set to true, set the amount to the same as billAmount
            // This enables payment without CVV for any amount
            try {
                val method = PortmoneSDK::class.java.getDeclaredMethod(
                    "setBillAmountWithoutCvvConfirmation",
                    Double::class.java
                )
                method.invoke(null, payParams.billAmount)
            } catch (e: Exception) {
                Log.e(TAG, "Error setting bill amount without CVV confirmation", e)
            }
        } else {
            // Reset the amount without CVV confirmation to 0 to ensure CVV is required
            try {
                val method = PortmoneSDK::class.java.getDeclaredMethod(
                    "setBillAmountWithoutCvvConfirmation",
                    Double::class.java
                )
                method.invoke(null, 0.0)
            } catch (e: Exception) {
                Log.e(TAG, "Error setting bill amount without CVV confirmation", e)
            }
        }

        // Enable fingerprint payment if requested
        if (payParams.paymentFlowType?.withoutCVV == true) {
            try {
                val method = PortmoneSDK::class.java.getDeclaredMethod(
                    "setFingerprintPaymentEnable",
                    Boolean::class.java
                )
                method.invoke(null, true)
            } catch (e: Exception) {
                Log.e(TAG, "Error enabling fingerprint payment", e)
            }
        }

        // Check if we should use Google Pay
        val useOnlyGooglePay = payParams.paymentFlowType?.payWithAppleGPay == true

        return if (useOnlyGooglePay) {
            PortmoneTokenPaymentParams(
                payParams.payeeId,
                payParams.billNumber ?: "",
                "", // shopBillId (optional, not exposed in our API)
                payParams.preauthFlag ?: false,
                payParams.billCurrency ?: "UAH",
                payParams.attribute1 ?: "",
                payParams.attribute2 ?: "",
                payParams.attribute3 ?: "",
                payParams.attribute4 ?: "",
                payParams.attribute5 ?: "",
                payParams.billAmount,
                tokenParams.cardNumberMasked,
                tokenParams.tokenData,
                payParams.description ?: "",
                true, // onlyGooglePay
                false, // testEnvironment
                false  // privatPayEnabled
            )
        } else {
            PortmoneTokenPaymentParams(
                payParams.payeeId,
                payParams.billNumber ?: "",
                "", // shopBillId (optional, not exposed in our API)
                payParams.preauthFlag ?: false,
                payParams.billCurrency ?: "UAH",
                payParams.attribute1 ?: "",
                payParams.attribute2 ?: "",
                payParams.attribute3 ?: "",
                payParams.attribute4 ?: "",
                payParams.attribute5 ?: "",
                payParams.billAmount,
                tokenParams.cardNumberMasked,
                tokenParams.tokenData,
                payParams.description ?: ""
            )
        }
    }

    private fun parseColor(colorString: String): Int {
        return try {
            if (colorString.startsWith("#")) {
                Color.parseColor(colorString)
            } else {
                Color.parseColor("#$colorString")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing color: $colorString", e)
            Color.BLACK // Default color in case of error
        }
    }
}