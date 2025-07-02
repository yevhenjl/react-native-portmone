// @ts-nocheck
import { useCallback, useEffect, useState } from 'react'
import {
  KeyboardProvider,
  useKeyboardController,
} from 'react-native-keyboard-controller'
import {
  ActivityIndicator,
  Alert,
  Platform,
  ScrollView,
  Switch,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  StyleSheet,
} from 'react-native'

import {
  Currency,
  Language,
  NitroHfPortmone,
  PaymentStatus,
  PaymentType,
  TimeoutValues,
} from 'react-native-portmone'
import { useMMKVString } from 'react-native-mmkv'

// Timeout options
const TIMEOUT_OPTIONS = [
  { label: 'Default (1 hour)', value: TimeoutValues.ONE_HOUR },
  { label: '5 minutes', value: 5 * 60 * 1000 },
  { label: '15 minutes', value: TimeoutValues.FIFTEEN_MINUTES },
  { label: '30 minutes', value: TimeoutValues.THIRTY_MINUTES },
  { label: '1 hour', value: TimeoutValues.ONE_HOUR },
  { label: '2 hours', value: 2 * 60 * 60 * 1000 },
  { label: 'Custom', value: -1 },
]

const merchantIdentifier = 'merchant.com'

const Page = () => {
  const [isProcessing, setIsProcessing] = useState(false)
  const { setEnabled } = useKeyboardController()
  // Saved card info
  const [token, setCardToken] = useMMKVString('card.token')
  const [mask, setCardMask] = useMMKVString('card.mask')

  // Payment parameters
  const [payeeId, setPayeeId] = useState('12345') // Example payee ID, replace with your actual Portmone payee ID
  const [amount, setAmount] = useState('1.00')
  const [description, setDescription] = useState('Test payment')
  const [billNumber, setBillNumber] = useState(`BILL-${Date.now()}`)

  // Timeout settings
  const [selectedTimeout, setSelectedTimeout] = useState<number>(
    TimeoutValues.ONE_HOUR
  )
  const [customTimeoutMinutes, setCustomTimeoutMinutes] = useState('60')
  const [useCustomTimeout, setUseCustomTimeout] = useState(false)

  // Advanced settings
  const [showAdvancedSettings, setShowAdvancedSettings] = useState(false)
  const [disableReturnToDetails, setDisableReturnToDetails] = useState(false)
  const [showReceiptScreen, setShowReceiptScreen] = useState(true)

  // UI states
  const [loading, setLoading] = useState(false)
  const [status, setStatus] = useState('')
  const [statusType, setStatusType] = useState<
    'success' | 'error' | 'info' | null
  >(null)

  const applyTimeoutSetting = useCallback(() => {
    try {
      const timeoutValue = useCustomTimeout
        ? parseInt(customTimeoutMinutes, 10) * 60 * 1000
        : selectedTimeout === -1
          ? parseInt(customTimeoutMinutes, 10) * 60 * 1000
          : selectedTimeout

      if (isNaN(timeoutValue)) {
        console.error('Invalid timeout value')
        return
      }

      NitroHfPortmone.setTimeout(timeoutValue)
      console.log(`Timeout set to ${timeoutValue / 60000} minutes`)
    } catch (error) {
      console.error('Failed to set timeout:', error)
    }
  }, [customTimeoutMinutes, selectedTimeout, useCustomTimeout])

  const initializePortmoneSDK = useCallback(() => {
    try {
      // Initialize with styling options
      NitroHfPortmone.initialize(
        {
          titleColor: '#333333',
          backgroundColor: '#f8f9fa',
          buttonColor: '#007bff',
          buttonTitleColor: '#ffffff',
          buttonCornerRadius: 8,
        },
        Language.UKRAINIAN
      )

      // Apply initial timeout setting
      applyTimeoutSetting()

      console.log('Portmone SDK initialized successfully')
      setStatus('SDK initialized successfully')
      setStatusType('info')
    } catch (error: any) {
      console.error('Failed to initialize Portmone SDK:', error)
      setStatus(`SDK init error: ${error.message}`)
      setStatusType('error')
    }
  }, [applyTimeoutSetting])

  // Initialize SDK
  useEffect(() => {
    initializePortmoneSDK()
  }, [initializePortmoneSDK])

  // Apply timeout setting
  useEffect(() => {
    applyTimeoutSetting()
  }, [
    selectedTimeout,
    customTimeoutMinutes,
    useCustomTimeout,
    applyTimeoutSetting,
  ])

  // Apply return to details setting
  useEffect(() => {
    try {
      NitroHfPortmone.setReturnToDetailsDisabled(disableReturnToDetails)
      console.log(`Return to details disabled: ${disableReturnToDetails}`)
    } catch (error) {
      console.error('Failed to set return to details setting:', error)
    }
  }, [disableReturnToDetails])

  // Save card token for future use
  const saveCardToken = (inputToken: string, inputMask: string) => {
    setCardToken(inputToken)
    setCardMask(inputMask)
  }

  // Validate inputs before payment
  const validateInputs = () => {
    if (!payeeId.trim()) {
      Alert.alert('Error', 'Payee ID is required')
      return false
    }

    const amountValue = parseFloat(amount)
    // if (isNaN(amountValue) || amountValue <= 0) {
    //   Alert.alert('Error', 'Please enter a valid amount')
    //   return false
    // }

    return true
  }

  // Handle payment by card
  const handlePayByCard = async () => {
    if (!validateInputs()) return

    setEnabled(false)
    await new Promise((resolve) => setTimeout(resolve, 300))

    setLoading(true)
    setStatus('Processing payment...')
    setStatusType('info')

    try {
      const paymentParams = {
        description,
        billNumber: billNumber || `BILL-${Date.now()}`,
        billAmount: parseFloat(amount),
        billCurrency: Currency.UAH,
        payeeId,
        type: PaymentType.PAYMENT,
        paymentFlowType: {
          payWithCard: false,
          payWithAppleGPay: false, // Enable ApplePay or GPay according to the platform
        },
        merchantIdentifier,
      }

      const result = await NitroHfPortmone.payByCard(
        paymentParams,
        showReceiptScreen
      )

      // Check the payment status to determine next action
      switch (result.status) {
        case PaymentStatus.PAYED:
          setStatus(`Payment successful! Amount: ${result.billAmount} UAH`)
          setStatusType('success')

          // Save token for future payments if available
          if (result.token && result.cardMask) {
            await saveCardToken(result.token, result.cardMask)
          }
          break

        case PaymentStatus.DISMISSED:
          setStatus('Payment form was dismissed')
          setStatusType('info')
          break

        case PaymentStatus.CANCELED:
          setStatus('Payment was canceled by user')
          setStatusType('info')
          break

        case PaymentStatus.TIMEOUT:
          setStatus('Payment session timed out')
          setStatusType('error')
          break

        default:
          setStatus(`Payment completed with status: ${result.status}`)
          setStatusType('info')
      }

      console.log('Payment result:', result)

      // Generate new bill number for next payment
      setBillNumber(`BILL-${Date.now()}`)
    } catch (error: any) {
      setStatus(`Payment error: ${error.message}`)
      setStatusType('error')
      console.error('Payment error:', error)
    } finally {
      setEnabled(true)
      setLoading(false)
    }
  }

  // Handle payment by token (saved card)
  const handlePayByToken = async () => {
    if (!validateInputs()) return
    if (!token || !mask) {
      Alert.alert(
        'No Saved Card',
        'Please make a payment by card first to save your card details.'
      )
      return
    }

    setLoading(true)
    setStatus('Processing token payment...')
    setStatusType('info')

    try {
      const paymentParams = {
        description,
        billNumber: billNumber || `TOKEN-${Date.now()}`,
        billAmount: parseFloat(amount),
        billCurrency: Currency.UAH,
        payeeId,
        type: PaymentType.PAYMENT,
      }

      const tokenParams = {
        cardNumberMasked: mask,
        tokenData: token,
      }

      const result = await NitroHfPortmone.payByToken(
        paymentParams,
        tokenParams,
        showReceiptScreen
      )

      // Check the payment status to determine next action
      switch (result.status) {
        case PaymentStatus.PAYED:
          setStatus(
            `Token payment successful! Amount: ${result.billAmount} UAH`
          )
          setStatusType('success')
          break

        case PaymentStatus.DISMISSED:
          setStatus('Payment form was dismissed')
          setStatusType('info')
          break

        case PaymentStatus.CANCELED:
          setStatus('Payment was canceled by user')
          setStatusType('info')
          break

        case PaymentStatus.TIMEOUT:
          setStatus('Payment session timed out')
          setStatusType('error')
          break

        default:
          setStatus(`Payment completed with status: ${result.status}`)
          setStatusType('info')
      }

      console.log('Token payment result:', result)

      // Generate new bill number for next payment
      setBillNumber(`BILL-${Date.now()}`)
    } catch (error: any) {
      setStatus(`Token payment error: ${error.message}`)
      setStatusType('error')
      console.error('Token payment error:', error)
    } finally {
      setLoading(false)
    }
  }

  // Handle card saving (without payment)
  const handleSaveCard = async () => {
    if (!payeeId.trim()) {
      Alert.alert('Error', 'Payee ID is required')
      return
    }

    setLoading(true)
    setStatus('Saving card...')
    setStatusType('info')

    setEnabled(false)

    try {
      const params = {
        payeeId,
        description: 'Card registration',
        billNumber: `SAVE${Date.now()}`,
      }

      const result = await NitroHfPortmone.saveCard(params)

      // Check the operation status
      switch (result.status) {
        case PaymentStatus.PAYED:
        case PaymentStatus.PREAUTH:
          if (result.token && result.cardMask) {
            await saveCardToken(result.token, result.cardMask)
            setStatus(`Card saved successfully: ${result.cardMask}`)
            setStatusType('success')
          } else {
            setStatus('Card saved but no token received')
            setStatusType('info')
          }
          break

        case PaymentStatus.DISMISSED:
          setStatus('Card saving form was dismissed')
          setStatusType('info')
          break

        case PaymentStatus.CANCELED:
          setStatus('Card saving was canceled by user')
          setStatusType('info')
          break

        case PaymentStatus.TIMEOUT:
          setStatus('Card saving session timed out')
          setStatusType('error')
          break

        default:
          setStatus(`Card saving completed with status: ${result.status}`)
          setStatusType('info')
      }

      console.log('Card save result:', result)
    } catch (error: any) {
      setStatus(`Card saving error: ${error.message}`)
      setStatusType('error')
      console.error('Card saving error:', error)
    } finally {
      setEnabled(true)
      setLoading(false)
    }
  }

  // Clear saved card
  const handleClearSavedCard = async () => {
    try {
      setCardToken('')
      setCardMask('')
      setStatus('Saved card cleared')
      setStatusType('info')
    } catch (error) {
      console.error('Failed to clear saved card:', error)
    }
  }

  return (
    <ScrollView
      bottomOffset={100}
      contentContainerStyle={styles.scrollContent}
      showsVerticalScrollIndicator={false}
    >
      <View style={styles.container}>
        <Text style={styles.title}>Portmone Payment Demo</Text>

        {/* Payment Parameters Form */}
        <View style={styles.formSection}>
          <Text style={styles.sectionTitle}>Payment Parameters</Text>

          <Text style={styles.label}>Payee ID</Text>
          <TextInput
            style={styles.input}
            value={payeeId}
            onChangeText={setPayeeId}
            placeholder="Portmone Payee ID"
            keyboardType="number-pad"
          />

          <Text style={styles.label}>Amount (UAH)</Text>
          <TextInput
            style={styles.input}
            value={amount}
            onChangeText={setAmount}
            placeholder="0.00"
            keyboardType="decimal-pad"
          />

          <Text style={styles.label}>Description</Text>
          <TextInput
            style={styles.input}
            value={description}
            onChangeText={setDescription}
            placeholder="Payment description"
          />

          <Text style={styles.label}>Bill Number</Text>
          <TextInput
            style={styles.input}
            value={billNumber}
            onChangeText={setBillNumber}
            placeholder="Generated bill number"
          />
        </View>

        {/* Timeout Settings */}
        <View style={styles.formSection}>
          <View style={styles.sectionHeaderRow}>
            <Text style={styles.sectionTitle}>Timeout Settings</Text>
          </View>

          <Text style={styles.label}>Session Timeout</Text>
          <TouchableOpacity
            style={styles.dropdownButton}
            onPress={() => {
              // Show modal or dropdown menu with options
              Alert.alert(
                'Select Timeout',
                'Choose a timeout value',
                TIMEOUT_OPTIONS.map((option) => ({
                  text: option.label,
                  onPress: () => {
                    setSelectedTimeout(option.value)
                    if (option.value === -1) {
                      setUseCustomTimeout(true)
                    } else {
                      setUseCustomTimeout(false)
                    }
                  },
                })),
                { cancelable: true }
              )
            }}
          >
            <Text style={styles.dropdownButtonText}>
              {TIMEOUT_OPTIONS.find(
                (option) => option.value === selectedTimeout
              )?.label || 'Select timeout'}
            </Text>
          </TouchableOpacity>

          {(useCustomTimeout || selectedTimeout === -1) && (
            <View>
              <Text style={styles.label}>Custom Timeout (minutes)</Text>
              <TextInput
                style={styles.input}
                value={customTimeoutMinutes}
                onChangeText={setCustomTimeoutMinutes}
                placeholder="Minutes"
                keyboardType="number-pad"
              />
            </View>
          )}
        </View>

        {/* Advanced Settings */}
        <TouchableOpacity
          style={styles.advancedSettingsButton}
          onPress={() => setShowAdvancedSettings(!showAdvancedSettings)}
        >
          <Text style={styles.advancedSettingsText}>
            {showAdvancedSettings
              ? 'Hide Advanced Settings'
              : 'Show Advanced Settings'}
          </Text>
        </TouchableOpacity>

        {showAdvancedSettings && (
          <View style={styles.formSection}>
            <Text style={styles.sectionTitle}>Advanced Settings</Text>

            <View style={styles.switchRow}>
              <Text style={styles.switchLabel}>Disable Return to Details</Text>
              <Switch
                value={disableReturnToDetails}
                onValueChange={setDisableReturnToDetails}
              />
            </View>

            <View style={styles.switchRow}>
              <Text style={styles.switchLabel}>Show Receipt Screen</Text>
              <Switch
                value={showReceiptScreen}
                onValueChange={setShowReceiptScreen}
              />
            </View>
          </View>
        )}

        {/* Saved Card Info */}
        {token ? (
          <View style={styles.savedCardSection}>
            <Text style={styles.sectionTitle}>Saved Card</Text>
            <Text style={styles.cardText}>{mask}</Text>
            <TouchableOpacity
              style={styles.clearButton}
              onPress={handleClearSavedCard}
            >
              <Text style={styles.clearButtonText}>Clear Saved Card</Text>
            </TouchableOpacity>
          </View>
        ) : null}

        {/* Payment Buttons */}
        <View style={styles.buttonSection}>
          {loading ? (
            <ActivityIndicator
              size="large"
              color="#007bff"
              style={styles.loader}
            />
          ) : (
            <>
              <TouchableOpacity
                style={styles.payButton}
                onPress={handlePayByCard}
                disabled={loading}
              >
                <Text style={styles.payButtonText}>Pay by Card</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[
                  styles.payButton,
                  (!token || loading) && styles.disabledButton,
                ]}
                onPress={handlePayByToken}
                disabled={!token || loading}
              >
                <Text style={styles.payButtonText}>Pay by Token</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.saveButton}
                onPress={handleSaveCard}
                disabled={loading}
              >
                <Text style={styles.saveButtonText}>Save Card Only</Text>
              </TouchableOpacity>
            </>
          )}
        </View>

        {/* Status Display */}
        {status ? (
          <View
            style={[
              styles.statusContainer,
              statusType === 'success' && styles.successStatus,
              statusType === 'error' && styles.errorStatus,
              statusType === 'info' && styles.infoStatus,
            ]}
          >
            <Text style={styles.statusText}>{status}</Text>
          </View>
        ) : null}
      </View>
    </ScrollView>
  )
}

const styles = StyleSheet.create({
  scrollContent: {
    flexGrow: 1,
    padding: 16,
  },
  container: {
    flex: 1,
    marginTop: 24,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 24,
    textAlign: 'center',
  },
  formSection: {
    backgroundColor: '#fff',
    borderRadius: 8,
    padding: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3,
    elevation: 2,
  },
  sectionHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  label: {
    fontSize: 14,
    fontWeight: '500',
    marginBottom: 4,
  },
  input: {
    height: 48,
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 6,
    paddingHorizontal: 12,
    marginBottom: 16,
    fontSize: 16,
  },
  dropdownButton: {
    height: 48,
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 6,
    paddingHorizontal: 12,
    marginBottom: 16,
    justifyContent: 'center',
  },
  dropdownButtonText: {
    fontSize: 16,
    color: '#333',
  },
  switchRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 8,
    marginBottom: 8,
  },
  switchLabel: {
    fontSize: 16,
    flex: 1,
  },
  advancedSettingsButton: {
    paddingVertical: 12,
    marginBottom: 16,
    alignItems: 'center',
  },
  advancedSettingsText: {
    color: '#007bff',
    fontWeight: '500',
  },
  savedCardSection: {
    backgroundColor: '#f0f9ff',
    borderRadius: 8,
    padding: 16,
    marginBottom: 16,
    borderLeftWidth: 4,
    borderLeftColor: '#007bff',
  },
  cardText: {
    fontSize: 18,
    marginBottom: 12,
  },
  clearButton: {
    backgroundColor: 'transparent',
    paddingVertical: 6,
  },
  clearButtonText: {
    color: '#dc3545',
    fontSize: 14,
    fontWeight: '500',
  },
  buttonSection: {
    marginBottom: 24,
  },
  payButton: {
    backgroundColor: '#007bff',
    paddingVertical: 14,
    borderRadius: 6,
    marginBottom: 12,
    alignItems: 'center',
  },
  payButtonText: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 16,
  },
  saveButton: {
    backgroundColor: '#6c757d',
    paddingVertical: 14,
    borderRadius: 6,
    alignItems: 'center',
  },
  saveButtonText: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 16,
  },
  disabledButton: {
    backgroundColor: '#b0b0b0',
  },
  loader: {
    marginVertical: 20,
  },
  statusContainer: {
    padding: 16,
    borderRadius: 8,
    marginBottom: 16,
  },
  successStatus: {
    backgroundColor: '#d4edda',
    borderLeftWidth: 4,
    borderLeftColor: '#28a745',
  },
  errorStatus: {
    backgroundColor: '#f8d7da',
    borderLeftWidth: 4,
    borderLeftColor: '#dc3545',
  },
  infoStatus: {
    backgroundColor: '#cce5ff',
    borderLeftWidth: 4,
    borderLeftColor: '#007bff',
  },
  statusText: {
    fontSize: 16,
  },
})

const App = () => {
  return (
    <KeyboardProvider>
      <Page />
    </KeyboardProvider>
  )
}
export default App
