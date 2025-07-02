import { NitroModules } from 'react-native-nitro-modules'
import type { HfPortmone } from './specs/HfPortmone.nitro'
import type {
  PaymentParams,
  TokenPaymentParams,
  PreauthParams,
  StyleOptions,
  PaymentResult,
} from './types'
import { PaymentStatus, Currency, PaymentType, Language } from './types'

/**
 * Portmone payment module for React Native
 *
 * This module provides a React Native wrapper around the Portmone SDK,
 * allowing you to integrate payment functionality into your React Native app.
 */
export const NitroHfPortmone =
  NitroModules.createHybridObject<HfPortmone>('HfPortmone')

// Common timeout values in milliseconds
export const TimeoutValues = {
  FIFTEEN_MINUTES: 15 * 60 * 1000,
  THIRTY_MINUTES: 30 * 60 * 1000,
  ONE_HOUR: 60 * 60 * 1000,
}

// Export all necessary types and enums
export { PaymentStatus, Currency, PaymentType, Language }
export type {
  PaymentParams,
  TokenPaymentParams,
  PreauthParams,
  StyleOptions,
  PaymentResult,
}
