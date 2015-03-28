require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_15juOhE7JwniA027u2zCWf3n",
      "created" =>  1427212615,
      "livemode" =>  false,
      "type" =>  "charge.succeeded",
      "data" =>  {
        "object" =>  {
          "id" =>  "ch_15juOhE7JwniA0276Fslgi4s",
          "object" =>  "charge",
          "created" =>  1427212615,
          "livemode" =>  false,
          "paid" =>  true,
          "status" =>  "succeeded",
          "amount" =>  999,
          "currency" =>  "usd",
          "refunded" =>  false,
          "source" =>  {
            "id" =>  "card_15juOdE7JwniA027kfFsghbg",
            "object" =>  "card",
            "last4" =>  "4242",
            "brand" =>  "Visa",
            "funding" =>  "credit",
            "exp_month" =>  3,
            "exp_year" =>  2017,
            "fingerprint" =>  "VBjjFK12L1YtJfTB",
            "country" =>  "US",
            "name" =>  nil,
            "address_line1" =>  nil,
            "address_line2" =>  nil,
            "address_city" =>  nil,
            "address_state" =>  nil,
            "address_zip" =>  nil,
            "address_country" =>  nil,
            "cvc_check" =>  "pass",
            "address_line1_check" =>  nil,
            "address_zip_check" =>  nil,
            "dynamic_last4" =>  nil,
            "metadata" =>  {},
            "customer" =>  "cus_5vlwvWtYjPMEPS"
          },
          "captured" =>  true,
          "balance_transaction" =>  "txn_15juOhE7JwniA027PPI4H6oy",
          "failure_message" =>  nil,
          "failure_code" =>  nil,
          "amount_refunded" =>  0,
          "customer" =>  "cus_5vlwvWtYjPMEPS",
          "invoice" =>  "in_15juOhE7JwniA027U7OcxBIc",
          "description" =>  nil,
          "dispute" =>  nil,
          "metadata" =>  {},
          "statement_descriptor" =>  nil,
          "fraud_details" =>  {},
          "receipt_email" =>  nil,
          "receipt_number" =>  nil,
          "shipping" =>  nil,
          "application_fee" =>  nil,
          "refunds" =>  {
            "object" =>  "list",
            "total_count" =>  0,
            "has_more" =>  false,
            "url" =>  "/v1/charges/ch_15juOhE7JwniA0276Fslgi4s/refunds",
            "data" =>  []
          }
        }
      },
      "object" =>  "event",
      "pending_webhooks" =>  1,
      "request" =>  "iar_5vlwjiawWhaVgH",
      "api_version" =>  "2015-02-18"
    }
  end
  
  it "creates a payment with the webhook from strpie for charge succeeded.", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5vlwvWtYjPMEPS")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5vlwvWtYjPMEPS")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5vlwvWtYjPMEPS")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15juOhE7JwniA0276Fslgi4s")
  end
end