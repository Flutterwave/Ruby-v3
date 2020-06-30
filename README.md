# Flutterwave V3 SDK

This is a Ruby gem for easy integration of Flutterwave V3 API for various applications written in Ruby language from [Flutterwave](https://rave.flutterwave.com/)

# V3 Documentation

See [Here](https://developer.flutterwave.com/reference) for Flutterwave V3 API Docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flutterwave_sdk'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install flutterwave_sdk

## Usage

## Instantiate Flutterwave Object
To use [Flutterwave Ruby SDK](https://ravesandbox.flutterwave.com), you need to instantiate the RaveRuby class with your [API](https://dashboard.flutterwave.com/dashboard/settings/apis) keys which are your public, secret and encryption keys. We recommend that you store your API keys in your environment variable named `FLUTTERWAVE_PUBLIC_KEY`, `FLUTTERWAVE_SECRET_KEY` and `FLUTTERWAVE_ENCRYPTION_KEY`. Instantiating your flutterwave object after adding your API keys in your environment is as illustrated below:

```ruby
payment = Flutterwave.new
```
This throws a `FLUTTERWAVEBadKeyError` if no key is found in the environment variable or invalid public or secret key is found.

#### Instantiate FLutterwave object in sandbox without environment variable:

You can instantiate your Flutterwave object by setting your public, secret and encryption keys by passing them as an argument of the `Flutterwave` class just as displayed below: 

```ruby
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxx-X", "FLWSECK-xxxxxxxxx-X", "xxxxxxxxxxx")
```

#### `NOTE:` It is best practice to always set your API keys to your environment variable for security purpose. Please be warned not use this package without setting your API keys in your environment variables in production.

#### To instantiate Flutterwave object in production with environment variable:

Simply use it as displayed below:

```ruby
Payment = Flutterwave.new("YOUR_FLUTTERWAVE_LIVE_PUBLIC_KEY", "YOUR_FLUTTERWAVE_LIVE_SECRET_KEY", "YOUR_ENCRYPTION_KEY", true)
```

### Flutterwave Objects
- [Card.new(payment)](#cardnewpayment)
- [AccountPayment.new(payment)](#accountpaymentnewpayment)
- [Bank.new(payment)](#banknewpayment)
- [Bills.new(payment)](#billsnewpayment)
- [BankTransfer.new(payment)](banktransfernewpayment)
- [Beneficiaries.new(payment)](#beneficiariesnewpayment)
- [USSD.new(payment)](#ussdnewpayment)
- [Transfer.new(payment)](#transfernewpayment)
- [VirtualCard.new(payment)](#virtualcardnewpayment)
- [TokenizedCharge.new(payment)](#tokenizedchargenewpayment)
- [Settlements.new(payment)](#settlementsnewpayment)
- [QR.new(payment)](#qrnewpayment)
- [Transactions.new(payment)](#transactionsnewpayment)
- [VirtualAccountNumber.new(payment)](#virtualaccountnumbernewpayment)
- [Subscriptions.new(payment)](#subscriptionsnewpayment)
- [OTP.new(payment)](#otpnewpayment)
- [Subaccount.new(payment)](#subaccountnewpayment)
- [PaymentPlan.new(payment)](#paymentplannewpayment)
- [MobileMoney.new(payment)](#mobilemoneynewpayment)
- [Misc.new(payment)](#miscnewpayment)
- [Preauth.new(payment)](preauthnewpayment)

## Card.new(payment)

>  <mark>NB - Flutterwave's direct card charge endpoint requires PCI-DSS compliance </mark>

> To charge cards, you will need to be PCI DSS compliant. If you are, you can proceed to charge cards.
Alternatively, you can use any of our other payment methods such as Standard, Inline or SDKs which do not require processing card details directly and do not also require payload encryption.


To perform account transactions, instantiate the card object and pass Flutterwave object as its argument.
#### Its functions includes:

- .initiate_charge
- .validate_charge
- .verify_charge


## Full Account Transaction Flow

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxx-X", "FLWSECK-xxxxxxxxx-X", "xxxxxxxxxxxxxxxxxxxxxxx")

# This is used to perform card charge

payload = {

    "card_number" => "5531886652142950",
    "cvv" => "564",
    "expiry_month" => "09",
    "expiry_year" => "22",
    "currency" => "NGN",
    "amount" => "10",
    "email" => "xxxxxxxxxx@gmail.com",
    "fullname" => "Test Name",
    "tx_ref" => "MC-3243e-if-12",
    "redirect_url" => "https://webhook.site/399"
    
}
charge_card = Card.new(payment)

response = charge_card.initiate_charge(payload)
puts response

# update payload with suggested auth
if response["meta"]["authorization"]["mode"]
    suggested_auth = response["meta"]["authorization"]["mode"]
    auth_arg = charge_card.get_auth_type(suggested_auth)
    if auth_arg == :pin
        updated_payload = charge_card.update_payload(suggested_auth, payload, pin: { "pin" => "3310"} )
    elsif auth_arg == :address
        updated_payload = charge_card.update_payload(suggested_auth, payload, address:{ "zipcode"=> "07205", "city"=> "Hillside", "address"=> "470 Mundet PI", "state"=> "NJ", "country"=> "US"})
    end

    #  perform the second charge after payload is updated with suggested auth
    response = charge_card.initiate_charge(updated_payload)
    print response
    
   # perform validation if it is required
    if response["data"]["status"] == "pending" || "success-pending-validation"
        response = charge_card.validate_charge(response["data"]["flw_ref"], "12345")
        print response
    end
else
    # You can handle the get the auth url from this response and load it for the customer to complete the transaction if an auth url is returned in the response.
    print response
end

# verify charge
response = charge_card.verify_charge(response["data"]["id"])
print response

```

## AccountPayment.new(payment)
#### Its functions includes:

- .initiate_charge
- .validate_charge
- .verify_charge

## Full Account Transaction Flow

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxx-X", "FLWSECK-xxxxxxx-X", "xxxxxxx")

payload = {
    "tx_ref" => "MC-1585230ew9v505010",
    "amount" => "100",
    "account_bank" => "044",
    "account_number" => "0690000037",
    "currency" => "NGN",
    "email" => "xxxxxxx@gmail.com",
    "phone_number" => "09000000000",
    "fullname" => "Test Name"
}

account_payment_ng = AccountPayment.new(payment)

response = account_payment_ng.initiate_charge(payload)
print response

#validate payment with OTP
if response["data"]["meta"]["authorization"]["mode"] == "otp"
    response = account_payment_ng.validate_charge(response["data"]["flw_ref"], "12345")
    print response
else
    print response

end

#verify transaction
response = account_payment_ng.verify_charge(response["data"]["tx_ref"])

print response

```


## Bank.new(payment)
#### Its functions includes:

- .get_all_banks
- .get_bank_branch

## See the full flow below

```ruby

require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxx-X", "FLWSECK-xxxxxxxxxx-X", "xxxxxxxxx")
bank = Bank.new(payment)

#get all banks
response = bank.get_all_banks("NG")
 print response

# get bank branches
response = bank.get_bank_branch(280)
 print response

```

## Bills.new(payment)
#### Its functions includes:

- .create_bill_payment
- .create_bulk_bill_payments
- .get_status_of_a_bill_payment
- .update_bills_order
- .validate_bill_service
- .get_bill_categories
- .get_bill_payment_agencies
- .get_amount_for_a_product
- .get_bill_payments
- .get_products_under_an_agency
- .create_order_using_billing_code_and_productid

## See full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-3xxxxxxxxxx-X", "FLWSECK_TEST-xxxxxxxxx-X", "xxxxxxxxxxxxx")
bill = Bills.new(payment)


# Create a bill payment 
payload = {
	"country" => "NG",
	"customer" => "+23490803840303",
	"amount" => 500,
	"recurrence" => "ONCE",
	"type" => "AIRTIME",
	"reference" => "ifunaya-0987654"
 }

 response = bill.create_bill_payment(payload)
 print response

#bulk bill payments
payload = {
    "bulk_reference" => "edf-12de5223d2f32",
    "callback_url" => "https://webhook.site/5f9a659a-11a2-4925-89cf-8a59ea6a019a",
    "bulk_data" => [
       {
          "country" => "NG",
          "customer" => "+23490803840303",
          "amount" => 500,
          "recurrence" => "WEEKLY",
          "type" => "AIRTIME",
          "reference" => "930049200929"
        },
        {
          "country" => "NG",
          "customer" => "+23490803840304",
          "amount" =>500,
          "recurrence" => "ONCE",
          "type": "AIRTIME",
          "reference" => "930004912332"
        }
    ]
}

response = bill.create_bulk_bill_payments(payload)
print response


#get the status of a bill payment
response = bill.get_status_of_a_bill_payment("BPUSSD1591303717500102")
print response

#get billers categories
response = bill.get_bill_categories
print response
```

## BankTransfer.new(payment)
#### Its functions includes:

- .initiate_charge
- .verify_charge

## See full flow below

```ruby

require './flutterwave_sdk'

# This is a FLutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxx-X", "FLWSECK-xxxxxxxxx-X", "xxxxxxxxxxx")

payload = {
    "tx_ref" => "MC-158523095056793",
    "amount" => "1500",
    "email" => "xxxxxxxxx@gmail.com",
    "phone_number" => "054709929220",
    "currency" => "NGN",
    "duration" => 2,
    "frequency" => 5,
    "narration" => "All star college salary for May",
    "is_permanent" => 1
}

bank_transfer = BankTransfer.new(payment)

response = bank_transfer.initiate_charge(payload)

print response

# verify transaction
response = bank_transfer.verify_charge(response["data"]["tx_ref"])

print response
```

## Beneficiaries.new(payment)
#### Its functions includes:

- .create_beneficiary
- .list_beneficiaries
- .fetch_beneficiary
- .delete_beneficiary

## See full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxx-X", "FLWSECK-xxxxxxxx-X", "xxxxxxxxxx")
Beneficiary = Beneficiaries.new(payment)

#create a beneficiary
payload = {
        "account_number" => "0690000032",
        "account_bank" => "044"
    }

response = Beneficiary.create_beneficiary(payload)
print response

#list beneficiaries

response = Beneficiary.list_beneficiaries

print response


#fetch beneficiary
response = Beneficiary.fetch_beneficiary(7369)
print response


#delete beneficiary
response = Beneficiary.delete_beneficiary(7369)
print response

```

## USSD.new(payment)
#### Its functions includes:

- .initiate_charge
- .verify_charge

## See full flow below

```ruby

require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxx-X", "FLWSECK-xxxxxxx-X", "xxxxxx")

payload = {
    "tx_ref" => "MC-15852309v5050w34",
    "account_bank" => "044",
    "amount" => "1500",
    "currency" => "NGN",
    "email" => "xxxxxxxxxxxxx@gmail.com",
    "phone_number" => "054709929220",
    "fullname" => "Test Name"

}

ussd = USSD.new(payment)

response = ussd.initiate_charge(payload)
print response


# verify transactioin with the id
response = ussd.verify_charge(283516336)
print response

```

## Transfer.new(payment)
#### Its functions includes:

- .transfer_fee
- .initiate_transfer
- .initiate_bulk_transfer
- .get_all_transfers
- .get_a_transfer

## See full flow below

```ruby


require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxx-X", "FLWSECK-xxxxxxx-X", "xxxxxxxxx")

transfer = Transfer.new(payment)
payload = {
    "account_bank" => "044",
    "account_number" => "0690000040",
    "amount" => 5000,
    "narration" => "Akhlm Pstmn Trnsfr xx007",
    "currency" => "NGN",
    "reference" => "eightm-pstmnpyt-rfxx007_P0MCKDU_1",
    "callback_url" => "https://webhook.site/b3e505b0-fe02-430e-a538-22bbbce8ce0d",
    "debit_currency" => "NGN"
}

response = transfer.initiate_transfer(payload)
print response


# get transfer fee
currency = "NGN"
amount = "5000"
response = transfer.transfer_fee(currency, amount)
print response

#get all transfers
response = transfer.get_all_transfers
print response

#get a transfer
response = transfer.get_a_transfer(125445)
print response

```

## VirtualCard.new(payment)
#### Its functions includes:

- .create_virtual_card
- .get_all_virtual_cards
- .get_virtual_card
- .fund_virtual_card
- .terminate_virtual_card
- .get_virtual_card_transactions
- .withdraw_from_virtual_card
- .block_unblock_virtual_card


## See full flow below

```ruby

require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-xxxxxxxx-X", "FLWSECK_TEST-xxxxxx-X", "xxxxxxxxx")
virtual_card = VirtualCard.new(payment)


create virtual card
    payload = {"currency" => "NGN",
    "amount" => 20000,
    "billing_name" => "Test Name",
    "billing_address" => "2014 Forest Hills Drive",
    "billing_city" => "Node",
    "billing_state" => "Javascript",
    "billing_postal_code" => "000009",
    "billing_country" => "NG",
    "callback_url" => "https://your-callback-url.com/"
}

response = virtual_card.create_virtual_card(payload)

print response


#get all virtual cards
response = virtual_card.get_all_virtual_cards
print response


#get a virtual card
response = virtual_card.get_virtual_card("594715a6-ae77-483c-811e-19057aedacff")
print response


#fund a virtual card
payload = {
    "debit_currency" => "NGN",
    "amount" => 4000
}

id = "594715a6-ae77-483c-811e-19057aedacff"
response = virtual_card.fund_virtual_card(id, payload)
print response

#get virtual card transactions
from = "2019-01-01"
to = "2020-01-13"
index = 0
size = 1

response = virtual_card.get_virtual_card_transactions("594715a6-ae77-483c-811e-19057aedacff", from, to, index, size)


#withdraw from a virtual card
payload = {
    "amount" => "1000"
}

id = "594715a6-ae77-483c-811e-19057aedacff"

response = virtual_card.withdraw_from_virtual_card(id,payload)
print response

#block/unblock virtualcard
id = "594715a6-ae77-483c-811e-19057aedacff"
status_action = "unblock"
response = virtual_card.block_unblock_virtual_card(id,status_action)
print response

```

## TokenizedCharge.new(payment)
#### Its functions includes:

- .tokenized_charge
- .verify_tokenized_charge
- .update_token
- .bulk_tokenized_charge
- .bulk_tokenized_charge_status
- .bulk_tokenized_charge_transactions

## See full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxx-X", "xxxxxxxxxxxxx")

# This is used to perform card charge
payload = {
    "token" => "flw-t1nf-264db944ee46d0a2627573a496f5432c-m03k",
    "currency" => "NGN",
    "country" => "NG",
    "amount" => "10",
    "email" => "user@example.com",
    "first_name" => "Test",
    "last_name" => "Name",
    "ip" => "pstmn",
    "narration" => "testing charge with token"
}

charge_with_token = TokenizedCharge.new(payment)
response = charge_with_token.tokenized_charge(payload)
print response

# Verify tokenized transaction
response = charge_with_token.verify_tokenized_charge(response["data"]["tx_ref"])
print response


#update token
payload = {
    "email" => "user@example.com",
    "first_name" => "Test",
    "last_name" => "Name", 
    "phone_number" => "09000000000000"
}
charge_with_token = TokenizedCharge.new(payment)

token = "flw-t1nf-264db944ee46d0a2627573a496f5432c-m03k"

response = charge_with_token.update_token(payload, token)
print response


#bulk tokenized charge

payload = {
        "title" => "test",
        "retry_strategy" => {
            "retry_interval" => 120,
            "retry_amount_variable" => 60,
            "retry_attempt_variable" => 2,
        },
        "bulk_data" => [
            {
                    "token" => "flw-t1nf-264db944ee46d0a2627573a496f5432c-m03k",
                    "currency" => "NGN",
                    "country" => "NG",
                    "amount" => "10",
                    "email" => "user@example.com",
                    "first_name" => "Test",
                    "last_name" => "Name",
                    "ip" => "pstmn",
                    "narration" => "testing charge with token",
            },
            {
                "token" => "flw-t1nf-264db944ee46d0a2627573a496f5432c-m03k",
                "currency" => "NGN",
                "country" => "NG",
                "amount" => "10",
                "email" => "user@example.com",
                "first_name" => "Test",
                "last_name" => "Name",
                "ip" => "pstmn",
                "narration" => "testing charge with token"
            }
        ]
    }

    charge_with_token = TokenizedCharge.new(payment)
    response = charge_with_token.bulk_tokenized_charge(payload)

print response


#get status of bulk tokenized charges
id =  175
charge_with_token = TokenizedCharge.new(payment)
response = charge_with_token.bulk_tokenized_charge_status(id)
print response


#fetch bulk tokenized transactions
id =  175
charge_with_token = TokenizedCharge.new(payment)
response = charge_with_token.bulk_tokenized_charge_transactions(id)
print response

```

## Settlements.new(payment)
#### Its functions includes:

- .get_settlements
- .get_settlement

## See full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-xxxxxxxxx-X", "FLWSECK_TEST-xxxxxxxxxx-X", "xxxxxxxxxxxxx")
settlement = Settlements.new(payment)


# get all settlements
response = settlement.get_settlements
print response


#get a settlment
response =settlement.get_settlement(63016)
print response

```

## QR.new(payment)
#### Its functions includes:

- .initiate_charge
- .verify_charge

## See full flow below

```ruby

require './flutterwave_sdk'

# This is a FLutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxx-X", "xxxxxxxxxxxxxxxx")

payload = {
    "tx_ref" => "MC-15852309v5050w34",
    "amount" => "1500",
    "currency" => "NGN",
    "email" => "xxxxxxxxxxxx@gmail.com",
    "phone_number" => "090000000000",
    "fullname" => "Test name"

}

qr = QR.new(payment)

response = qr.initiate_charge(payload)
print response

# verify QR transaction
response = qr.verify_charge(response["data"]["tx_ref"])
print response

```

## Transactions.new(payment)
#### Its functions includes:

- .transaction_fee
- .get_transactions
- .verify_transaction
- .transactions_events
- .initiate_a_refund
- .resend_transaction_webhook

## see full flow below

```ruby

require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxxxxxxxx-X", "xxxxxxxxxxxxxxx")

fee = Transactions.new(payment)
currency = "NGN"
amount = "1000"
response = fee.transaction_fee(currency, amount)
print response


# get Transactions
fee = Transactions.new(payment)
response = fee.get_transactions
print response

# get transaction events
fee = Transactions.new(payment)
response = fee.transactions_events(1321548)
print response

# initiate a refund
payload = {
    "amount" => "5"
}
# id = 1321548
fee = Transactions.new(payment)
response = fee.initiate_a_refund(payload, 1321548)
print response

#resend transaction webhook
payload = {
    "id" => 1321548
}
fee = Transactions.new(payment)
response = fee.resend_transactions_webhook(payload)
print response

```

## VirtualAccountNumber.new(payment)
#### Its functions includes:

- .create_virtual_account_number
- .create_bulk_virtual_account_number
- .get_bulk_virtual_account_number
- .get_virtual_account_number

# see full flow below

```ruby

require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-xxxxxxxx-X", "FLWSECK_TEST-xxxxxxxxxx-X", "xxxxxxxxx")
account_number = VirtualAccountNumber.new(payment)


# #create virtual account number
 payload = {
    "email" => "xxxxxxxxxx@gmail.com",
    "duration" => 5,
    "frequency" => 5,
    "is_permanent" => true,
    "tx_ref" => "jhn-Test-10192029920"
}

response = account_number.create_virtual_account_number(payload)
print response

#bulk account number
payload = {
    "email" => "xxxxxxxxx@gmail.com",
    "duration" => 5,
    "accounts" => 5,
    "is_permanent" => true,
    "tx_ref" => "jhn-Test-10192029920"
}

response = account_number.create_bulk_virtual_account_number(payload)
print response


# get bulk virtual account number
response = account_number.get_bulk_virtual_account_number("-RND_1071591303048505")
print response

# Get a virtual account number 
response = account_number.get_virtual_account_number("URF_1591302653177_6055335")
print response

```

## Subscriptions.new(payment)
#### Its functions includes:

- .get_all_subscriptions
- .cancel_subscription
- .activate_subscription

# see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxx-X", "FLWSECK-xxxxxxxxxx-X", "xxxxxxxxxxx")
subscription = Subscriptions.new(payment)

#get all subscriptions
response = subscription.get_all_subscriptions
print response

#cancel subscription
response = subscription.cancel_subscription(247490)
print response

#activate subcription
response = subscription.activate_subscription(247490)
print response

```

## OTP.new(payment)
#### Its functions includes:

- .create_otp
- .validate_otp

# see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-xxxxxxxxxxxxxx-X", "FLWSECK_TEST-xxxxxxxxxxxx-X", "xxxxxxxxx")
otp = OTP.new(payment)

payload = {
    "length" => 7,
	"customer" => { "name" => "Test", "email" => "xxxxxxxxxxx@gmail.com", "phone" => "2348131149273" },
	"sender" => "Test Name",
	"send" => true,
	"medium" => ["email", "whatsapp"],
	"expiry" => 5
}

response = otp.create_otp(payload)
print response

#validate otp
payload = {
    "otp" => 481208
}

reference = "CF-BARTER-20190420022611377491"
response = otp.validate_otp(reference, payload)
print response

```

## Subaccount.new(payment)
#### Its functions includes:

- .create_subaccount
- .fetch_subaccounts
- .fetch_subaccount
- .update_subaccount
- .delete_subaccount

## see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK_TEST-xxxxxxxx-X", "FLWSECK_TEST-xxxxxxxx-X", "xxxxxx")
subaccount = Subaccount.new(payment)

#create subaccount
payload = {
    "account_bank" => "044",
    "account_number" => "0690000036",
    "business_name" => "Test Name",
    "business_email" => "xxxxxx@gmail.com",
    "business_contact" => "Anonymous",
    "business_contact_mobile" => "090890382",
    "business_mobile" => "09087930450",
    "country" => "NG",
    "split_type" => "percentage",
    "split_value" => 0.5
}

reponse = subaccount.create_subaccount(payload)
print reponse

#fetch all subaccounts
reponse = subaccount.fetch_subaccounts
print reponse


#fetch a sub account
reponse = subaccount.fetch_subaccount(5740)
print reponse


#update subaccount
payload = {
    "business_email" => "xxxxx@gmail.com"
}
id = 5740
reponse = subaccount.update_subaccount(id, payload)
print reponse


#delete subaccount
reponse = subaccount.delete_subaccount(5740)
print reponse

```

## PaymentPlan.new(payment)
#### Its functions includes:

- .create_payment_plan
- .get_payment_plans
- .get_a_payment_plan
- .update_payment_plan
- .cancel_payment_plan

## see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxx-X", "FLWSECK-xxxxxxxxxx-X", "xxxxxxxxxxxxx")
payment_plan = PaymentPlan.new(payment)

#create payment plan
 payload = {
    "amount" => 5000,
    "name" =>  "the akhlm postman plan 2",
    "interval" => "monthly",
    "duration" => 48
 }

 response = payment_plan.create_payment_plan(payload)
 print response


#get payment plans
response = payment_plan.get_payment_plans
print response

#get a payment plan
response = payment_plan.get_a_payment_plan(5981)
print response

#update a payment plan
payload = {
    "name" => "Test name",
    "status" => "active"
}

response = payment_plan.update_payment_plan(5981, payload)
print response

#cancel payment plan
response = payment_plan.cancel_payment_plan(5981)
print response

```

## MobileMoney.new(payment)
#### Its functions includes:

- .initiate_charge
- .verify_charge

## see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxxxxxxx-X", "FLWSECK-xxxxxxxxxxxx-X", "xxxxxxxxxx")

# This is used to perform Mpesa transaction
payload =  {
    "tx_ref" => "khlm-158943942o3",
    "amount" => "50",
    "currency" => "KES",
    "email" => "johnmadakin@gmail.com",
    "phone_number" => "054709929220",
    "fullname" => "John Madakin",
    "client_ip" => "154.123.220.1",
    "device_fingerprint" => "62wd23423rq32dskd4323qew1"
    
}

charge_mpesa = MobileMoney.new(payment)

response = charge_mpesa.initiate_charge(payload)
print response

#verify transaction 
response = charge_mpesa.verify_charge(response["data"]["tx_ref"])
print response


#zambia test

payload = {
    "tx_ref" => "MC-158523s09v5050e8",
    "amount" => "1500",
    "currency" => "ZMW",
    "network" => "MTN",
    "email" => "xxxxxxxxxx@gmail.com",
    "phone_number" => "054709929220",
    "fullname" => "Test Name"
}

charge_zambia = MobileMoney.new(payment)

response = charge_zambia.initiate_charge(payload)
print response

#verify transaction
response = charge_zambia.verify_charge(response["data"]["tx_ref"])
print response


# # Ghana mobile money test
payload = {
    "tx_ref" => "MC-158523s09v5050e8",
    "amount" => "150",
    "currency" => "GHS",
    "voucher" => "143256743",
    "network" => "MTN",
    "email" => "xxxxx@gmail.com",
    "phone_number" =>  "054709929220",
    "fullname": "Test Name"
}

charge_ghana = MobileMoney.new(payment)

#initiate transaction
response = charge_ghana.initiate_charge(payload)
print response

#verify transaction
response = charge_ghana.verify_charge(response["data"]["tx_ref"])
print response


# Rwanda mobile money test

payload = {
    "tx_ref" => "MC-158523s09v5050e8",
    "amount" => "1500",
    "currency" => "RWF",
    "network" => "MTN",
    "email" => "xxxxx@gmail.com",
    "phone_number" => "054709929220",
    "fullname" => "Test Name"
}

charge_rwanda = MobileMoney.new(payment)

response = charge_rwanda.initiate_charge(payload)
print response

# verify transaction
response = charge_rwanda.verify_charge(response["data"]["tx_ref"])
print response


#uganda test

payload = {
    "tx_ref" => "MC-1585230950500",
    "amount" => "1500",
    "email" => "xxxxxxxx@gmail.com",
    "phone_number" => "054709929220",
    "currency" => "UGX",
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment",
    "network" => "MTN"

}

charge_uganda = MobileMoney.new(payment)

response = charge_uganda.initiate_charge(payload)
print response

response = charge_uganda.verify_charge(response["data"]["tx_ref"])
print response

 # franco phone
payload = {
    "tx_ref" => "MC-1585230950501",
    "amount" => "1500",
    "email" => "xxxxxx@gmail.com",
    "phone_number" => "054709929220",
    "currency" => "XAF",
    "redirect_url" => "https://rave-webhook.herokuapp.com/receivepayment"

}

charge_franco = MobileMoney.new(payment)

response = charge_franco.initiate_charge(payload)
print response


response = charge_franco.verify_charge(response["data"]["tx_ref"])
print response
```

## Misc.new(payment)
#### Its functions includes:

_ .get_all_wallet_balance
- .get_balance_per_currency
- .resolve_account
- .resolve_bvn
- .resolve_card_bin

## see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxxx-X", "FLWSECK-xxxxx-X", "xxxxxxxxxxxxxxx")
misc = Misc.new(payment)

#get all wallet balance
response = misc.get_all_wallet_balance
print response


#get balance per cuurency
response = misc.get_balance_per_currency("NGN")
print response

#resolve account
payload = {
    "account_number" => "0690000032",
    "account_bank" => "044"
}
response = misc.resolve_account(payload)

print response

#resolve bvn
response = misc.resolve_bvn("12345678901")
print response


#resolve card bin
response = misc.resolve_card_bin(553188)
print response

```

## Preauth.new(payment)
#### Its functions includes:

- .capture_preauth
- .void_preauth
- .refund_preauth

## see full flow below

```ruby
require './flutterwave_sdk'

# This is a Flutterwave object which is expecting public, secret and encrption keys
payment = Flutterwave.new("FLWPUBK-xxxxxxxxx-X", "xxxxxxxxxxxxxx", "xxxxxxxxxxxxxx")

# This is used to perform preauth capture

auth = Preauth.new(payment)

payload = {
    "amount" => "50"
}

flw_ref = "FLW-MOCK-d6b76a67a639dc124917b8957baa5278"

repsonse = auth.capture_preauth(flw_ref, payload)
print response


#Void
response = auth.void_preauth(flw_ref)
print response


#Refund
payload = {
    "amount" => "30"
}

flw_ref = "FLW-MOCK-d6b76a67a639dc124917b8957baa5278"

response = auth.refund_preauth(flw_ref, payload)
print response


```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Iphytech/flutterwave_sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Iphytech/flutterwave_sdk/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlutterwaveSdk project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Iphytech/flutterwave_sdk/blob/master/CODE_OF_CONDUCT.md).
