# **react-native-portmone**

A React Native wrapper for the Portmone SDK (iOS and Android), enabling seamless integration of Portmone payment processing in your React Native applications.

## **Overview**

This library provides a React Native interface to Portmone's eCommerce SDK, allowing your users to make payments with credit and debit cards, save cards for future use, and process token-based payments.

## **Features**

- 💳 Process payments using payment cards
- 🔒 Save cards securely for future payments
- 🔄 Make payments using previously saved card tokens
- 🎨 Customize UI appearance with theming options
- 🌐 Support for multiple languages (Ukrainian, English)
- ⏱️ Configurable session timeout

## **Requirements**

- iOS 16.0+
- React Native 0.75.0+
- `react-native-nitro-modules` 0.25.1+

## **Installation**

```bash
npm install react-native-portmone
# or
yarn add react-native-portmone
```

### **iOS Setup**

The library relies on the Portmone iOS SDK, which is installed via CocoaPods:

```bash
# cd ios && pod install
```

## **Using with Expo**

This library is compatible with the Expo framework. To use it with Expo, follow these steps:

1. Install the required packages:

```bash
# npx expo install expo-build-properties react-native-nitro-modules
```

2. Configure your `app.json` to include the necessary plugins:

json

```javascript
"plugins": [
  "react-native-portmone",
  [
    "expo-build-properties",
    {
      "ios": {
        "deploymentTarget": "16.6",
        "extraPods": [
          {
            "name": "PortmoneSDKEcom",
            "configurations": [
              "Release",
              "Debug"
            ],
            "modular_headers": true,
            "version": "~> 1.7.22"
          }
        ]
      }
    }
  ]
]
```

3. Before using the library, you need to generate native code with:

```bash
# npx expo prebuild
```

This command creates the native iOS project with all the necessary configurations as described in the [Expo Continuous Native Generation documentation](https://docs.expo.dev/workflow/continuous-native-generation/).

## **Basic Usage**

```javascript
import {
  NitroHfPortmone,
  Currency,
  PaymentType,
  Language,
} from 'react-native-portmone'

// Initialize the SDK first
NitroHfPortmone.initialize(
  {
    // Optional styling options
    buttonColor: '#007bff',
    buttonTitleColor: '#ffffff',
    buttonCornerRadius: 8,
  },
  Language.UKRAINIAN // or Language.ENGLISH
)

// Make a payment
const makePayment = async () => {
  try {
    const paymentParams = {
      payeeId: '1234', // Your Portmone Payee ID
      billAmount: 100.5,
      billCurrency: Currency.UAH,
      description: 'Product purchase',
      billNumber: `ORDER-${Date.now()}`,
      type: PaymentType.PAYMENT,
    }

    const result = await NitroHfPortmone.payByCard(paymentParams, true)

    console.log('Payment successful!', result)

    // Save token for future use if available
    if (result.token && result.cardMask) {
      // Store these securely for token payments
      saveCardToken(result.token, result.cardMask)
    }
  } catch (error) {
    console.error('Payment failed', error)
  }
}
```

## **API Reference**

### **Methods**

#### **`initialize(styleOptions?: StyleOptions, language?: Language): void`**

Initializes the Portmone SDK with optional styling and language settings.

```javascript
NitroHfPortmone.initialize(
  {
    buttonColor: '#007bff',
    buttonTitleColor: '#ffffff',
  },
  Language.UKRAINIAN
)
```

#### **`payByCard(params: PaymentParams, showReceiptScreen?: boolean): Promise<PaymentResult>`**

Processes a payment using a payment card. Returns a promise that resolves to a payment result.

```javascript
const result = await NitroHfPortmone.payByCard(
  {
    payeeId: '1234',
    billAmount: 100.5,
    billCurrency: Currency.UAH,
    description: 'Product purchase',
    billNumber: 'ORDER-123',
  },
  true
)
```

#### **`payByToken(payParams: PaymentParams, tokenParams: TokenPaymentParams, showReceiptScreen?: boolean): Promise<PaymentResult>`**

Processes a payment using a previously saved card token.

```javascript
const result = await NitroHfPortmone.payByToken(
  {
    payeeId: '1234',
    billAmount: 100.5,
    billCurrency: Currency.UAH,
    description: 'Product purchase',
    billNumber: 'ORDER-123',
  },
  {
    cardNumberMasked: '411111******1111',
    tokenData: 'saved-card-token',
  },
  true
)
```

#### **`saveCard(params: PreauthParams): Promise<PaymentResult>`**

Saves a card for future token-based payments without making an actual payment. Note that this operation blocks 1 UAH on the card (automatically unblocked within 30 minutes).

```javascript
const result = await NitroHfPortmone.saveCard({
  payeeId: '1234',
  description: 'Card registration',
  billNumber: 'SAVE-123',
})
```

#### **`setTimeout(timeoutMs: number): void`**

Sets the timeout for payment sessions in milliseconds. Default is 1 hour.

```javascript
// Set timeout to 15 minutes
NitroHfPortmone.setTimeout(15 * 60 * 1000)
```

#### **`setReturnToDetailsDisabled(disabled: boolean): void`**

Configures whether to disable returning to the payment details screen after payment.

```javascript
NitroHfPortmone.setReturnToDetailsDisabled(true)
```

### **Types**

#### **`PaymentParams`**

Parameters for card and token payments.

```javascript
interface PaymentParams {
  description?: string;
  attribute1?: string;
  attribute2?: string;
  attribute3?: string;
  attribute4?: string;
  attribute5?: string;
  billNumber?: string;
  preauthFlag?: boolean;
  billCurrency?: string;
  billAmount: number;
  billAmountWcvv?: number;
  payeeId: string;
  type?: string;
  merchantIdentifier?: string;
  paymentFlowType?: PaymentFlowType;
}
```

#### **`TokenPaymentParams`**

Parameters for token-based payments.

```javascript
interface TokenPaymentParams {
  cardNumberMasked: string;
  tokenData: string;
}
```

#### **`PreauthParams`**

Parameters for saving a card.

```javascript
interface PreauthParams {
  payeeId: string;
  accountId?: string;
  description: string;
  billNumber?: string;
}
```

#### **`StyleOptions`**

UI customization options.

```javascript
interface StyleOptions {
  titleFontName?: string;
  titleColor?: string;
  titleBackgroundColor?: string;
  headersFontName?: string;
  headersColor?: string;
  headersBackgroundColor?: string;
  placeholdersFontName?: string;
  placeholdersColor?: string;
  textsFontName?: string;
  textsColor?: string;
  errorsFontName?: string;
  errorsColor?: string;
  backgroundColor?: string;
  resultMessageFontName?: string;
  resultMessageColor?: string;
  resultSaveReceiptColor?: string;
  infoTextsFont?: string;
  infoTextsColor?: string;
  buttonTitleFontName?: string;
  buttonTitleColor?: string;
  buttonColor?: string;
  buttonCornerRadius?: number;
  biometricButtonColor?: string;
}
```

#### **`PaymentResult`**

The result of a payment or card save operation.

```javascript
interface PaymentResult {
  billId?: string;
  status: string;
  billAmount: number;
  cardMask?: string;
  commissionAmount: number;
  receiptUrl?: string;
  contractNumber?: string;
  payDate?: number;
  payeeName?: string;
  token?: string;
}
```

### **Enums**

#### **`Currency`**

Supported currencies for payments.

```javascript
enum Currency {
  UAH = 'UAH',
  USD = 'USD',
  EUR = 'EUR',
  GBP = 'GBP',
  BYN = 'BYN',
  KZT = 'KZT',
}
```

#### **`PaymentType`**

Types of payments supported.

```javascript
enum PaymentType {
  PAYMENT = 'payment',
  MOBILE_PAYMENT = 'mobilePayment',
  ACCOUNT = 'account',
}
```

#### **`Language`**

Supported languages for the payment interface.

```javascript
enum Language {
  UKRAINIAN = 'ukrainian',
  ENGLISH = 'english',
}
```

#### **`PaymentStatus`**

Possible payment result statuses.

```javascript
enum PaymentStatus {
  PAYED = 'PAYED',
  PREAUTH = 'PREAUTH',
  CANCELED = 'canceled',
  DISMISSED = 'dismissed',
  TIMEOUT = 'timeout',
  SUCCESS = 'success',
  ERROR = 'error',
}
```

#### **`TimeoutValues`**

Predefined timeout values in milliseconds.

```javascript
export const TimeoutValues = {
  FIFTEEN_MINUTES: 15 * 60 * 1000,
  THIRTY_MINUTES: 30 * 60 * 1000,
  ONE_HOUR: 60 * 60 * 1000,
}
```

## **Advanced Usage Examples**

### **Using Apple Pay**

To enable Apple Pay payments, include it in the payment flow options:

```javascript
const paymentParams = {
  // ... other parameters
  paymentFlowType: {
    payWithCard: true,
    payWithAppleGPay: true,
  },
}

const result = await NitroHfPortmone.payByCard(paymentParams)
```

### **Using Card Tokens**

Save a card token from a successful payment:

```javascript
// After a successful payment
if (result.token && result.cardMask) {
  await AsyncStorage.setItem('CARD_TOKEN', result.token)
  await AsyncStorage.setItem('CARD_MASK', result.cardMask)
}
```

Make a payment using a saved token:

```javascript
const token = await AsyncStorage.getItem('CARD_TOKEN')
const mask = await AsyncStorage.getItem('CARD_MASK')

if (token && mask) {
  const result = await NitroHfPortmone.payByToken(
    {
      payeeId: '1234',
      billAmount: 100.5,
      billCurrency: Currency.UAH,
    },
    {
      cardNumberMasked: mask,
      tokenData: token,
    }
  )
}
```

### **Custom Styling**

Apply custom styling to the payment screens:

```javascript
NitroHfPortmone.initialize({
  // Title styles
  titleFontName: 'SFProText-Medium',
  titleColor: '#333333',
  titleBackgroundColor: '#FFFFFF',

  // Headers styles
  headersFontName: 'SFProText-Medium',
  headersColor: '#333333',
  headersBackgroundColor: '#F5F5F5',

  // Text styles
  textsFontName: 'SFProText-Regular',
  textsColor: '#333333',

  // Placeholder styles
  placeholdersFontName: 'SFProText-Regular',
  placeholdersColor: '#999999',

  // Button styles
  buttonTitleFontName: 'SFProText-Medium',
  buttonTitleColor: '#FFFFFF',
  buttonColor: '#0066CC',
  buttonCornerRadius: 8,

  // Background styles
  backgroundColor: '#F9F9F9',
})
```

### **Custom Timeout**

Configure a custom timeout for payment sessions:

```javascript
// Set a 15-minute timeout
NitroHfPortmone.setTimeout(15 * 60 * 1000)

// Or use predefined values
import { TimeoutValues } from 'react-native-portmone'
NitroHfPortmone.setTimeout(TimeoutValues.FIFTEEN_MINUTES)
```

## **Error Handling**

The library rejects promises with detailed error information:

```javascript
try {
  const result = await NitroHfPortmone.payByCard(params)
  // Handle successful payment
} catch (error) {
  // Check specific error types
  if (error.code === 1) {
    console.error('Root view controller not found')
  } else if (error.code === 3) {
    console.log('User canceled the payment')
  } else {
    console.error('Payment failed:', error.message)
  }
}
```

## **Getting Started with Portmone**

To use this library in a production environment, you need to:

1. Contact Portmone to obtain a merchant account and payee ID
2. Set up Apple Pay if you want to enable this payment method
3. Get implementation details from your Portmone account manager

Contact Portmone at: commerce@portmone.me

## **Portmone Documentation**

[Portmone eCommerce iOS SDK](https://docs.portmone.com.ua/docs/en/EcomSDKiOSEng/)

[Portmone eCommerce Android SDK](https://docs.portmone.com.ua/docs/en/EcomSDKAndroidEng/)

## **Portmone Native SDK (Github)**

[Portmone eCommerce iOS SDK](https://github.com/Portmone/IOS-e-Commerce-SDK)

[Portmone eCommerce Android SDK](https://github.com/Portmone/Android-e-Commerce-SDK)


## **Credits**

Built with [Nitro Modules](https://github.com/mrousavy/nitro) by [Marc Rousavy](https://github.com/mrousavy)
