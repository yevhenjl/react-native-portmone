export enum Currency {
  UAH = 'UAH',
  USD = 'USD',
  EUR = 'EUR',
  GBP = 'GBP',
  BYN = 'BYN',
  KZT = 'KZT',
}

export enum PaymentType {
  PAYMENT = 'payment',
  MOBILE_PAYMENT = 'mobilePayment',
  ACCOUNT = 'account',
}

export enum Language {
  UKRAINIAN = 'ukrainian',
  ENGLISH = 'english',
}

export enum PaymentStatus {
  // Standard Portmone statuses
  PAYED = 'PAYED',
  PREAUTH = 'PREAUTH',

  // User interaction statuses
  CANCELED = 'canceled',
  DISMISSED = 'dismissed',
  TIMEOUT = 'timeout',

  // Legacy status values - kept for backward compatibility
  SUCCESS = 'success',
  ERROR = 'error',
}

export interface PaymentFlowType {
  payWithCard?: boolean
  payWithAppleGPay?: boolean
  withoutCVV?: boolean
}

export interface PaymentParams {
  description?: string
  attribute1?: string
  attribute2?: string
  attribute3?: string
  attribute4?: string
  attribute5?: string
  billNumber?: string
  preauthFlag?: boolean
  billCurrency?: string
  billAmount: number
  billAmountWcvv?: number
  payeeId: string
  type?: string
  merchantIdentifier?: string
  paymentFlowType?: PaymentFlowType
}

export interface TokenPaymentParams {
  cardNumberMasked: string
  tokenData: string
}

export interface PreauthParams {
  payeeId: string
  accountId?: string
  description: string
  billNumber?: string
}

export interface StyleOptions {
  // Title styles
  titleFontName?: string
  titleColor?: string
  titleBackgroundColor?: string

  // Headers styles
  headersFontName?: string
  headersColor?: string
  headersBackgroundColor?: string

  // Placeholders styles
  placeholdersFontName?: string
  placeholdersColor?: string

  // Text input styles
  textsFontName?: string
  textsColor?: string

  // Error styles
  errorsFontName?: string
  errorsColor?: string

  // Background styles
  backgroundColor?: string

  // Result styles
  resultMessageFontName?: string
  resultMessageColor?: string
  resultSaveReceiptColor?: string

  // Info text styles
  infoTextsFont?: string
  infoTextsColor?: string

  // Button styles
  buttonTitleFontName?: string
  buttonTitleColor?: string
  buttonColor?: string
  buttonCornerRadius?: number
  biometricButtonColor?: string

  // Custom images - use string paths instead of React Native types
  // This will be handled in the native code separately
  successResultImage?: string
  failureResultImage?: string
}

export interface PaymentResult {
  billId?: string
  status: string
  billAmount: number
  cardMask?: string
  commissionAmount: number
  receiptUrl?: string
  contractNumber?: string
  payDate?: number
  payeeName?: string
  token?: string
}
