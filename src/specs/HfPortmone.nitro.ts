// src/specs/HfPortmone.nitro.ts
import { type HybridObject } from 'react-native-nitro-modules'
import type {
  PaymentParams,
  TokenPaymentParams,
  PreauthParams,
  StyleOptions,
  PaymentResult,
  Language,
} from '../types'

/**
 * Interface for Portmone payment integration with React Native.
 * Provides methods for card payments, token payments, and card saving functionality.
 */
export interface HfPortmone
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  /**
   * Initialize the SDK with styling options and language preference.
   * Should be called before making any payment requests.
   *
   * @param styleOptions Optional styling configuration for payment screens
   * @param language Optional language setting (ukrainian or english)
   */
  initialize(styleOptions?: StyleOptions, language?: Language): void

  /**
   * Set the payment form timeout in milliseconds.
   * After this time, any open payment form will be automatically closed.
   * If not set, defaults to 1 hour (3,600,000 ms).
   *
   * @param timeoutMs Timeout duration in milliseconds
   */
  setTimeout(timeoutMs: number): void

  /**
   * Make a payment using a payment card.
   * Displays a payment form where the user can enter their card details.
   *
   * @param params Payment parameters including amount, currency, and merchant details
   * @param showReceiptScreen Whether to show the receipt screen after successful payment
   * @returns Promise resolving to payment result or rejecting with error
   */
  payByCard(
    params: PaymentParams,
    showReceiptScreen?: boolean
  ): Promise<PaymentResult>

  /**
   * Make a payment using a previously saved card token.
   * User will only need to enter their CVV code unless withoutCVV is set to true.
   *
   * @param payParams Payment parameters including amount, currency, and merchant details
   * @param tokenParams Card token and masked card number from previous payment
   * @param showReceiptScreen Whether to show the receipt screen after successful payment
   * @returns Promise resolving to payment result or rejecting with error
   */
  payByToken(
    payParams: PaymentParams,
    tokenParams: TokenPaymentParams,
    showReceiptScreen?: boolean
  ): Promise<PaymentResult>

  /**
   * Save a card for future token-based payments.
   * This will block a small amount on the card (1 UAH) which is automatically unblocked.
   *
   * @param params Parameters for card saving including merchant ID
   * @returns Promise resolving to save result with token or rejecting with error
   */
  saveCard(params: PreauthParams): Promise<PaymentResult>

  /**
   * Configure whether to disable returning to payment details screen after payment.
   *
   * @param disabled Whether to disable the return to details feature
   */
  setReturnToDetailsDisabled(disabled: boolean): void
}
