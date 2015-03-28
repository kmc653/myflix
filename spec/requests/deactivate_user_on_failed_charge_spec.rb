require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_15lC7iE7JwniA027C0fVCQO9",
      "created" => 1427519082,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15lC7iE7JwniA027yhxH6aj1",
          "object" => "charge",
          "created" => 1427519082,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15lC7FE7JwniA027gg53BIo3",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 3,
            "exp_year" => 2018,
            "fingerprint" => "SR3feeGNXdhR4uSG",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_5w8SSvTMaX0fkI"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5w8SSvTMaX0fkI",
          "invoice" => nil,
          "description" => "payment to fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15lC7iE7JwniA027yhxH6aj1/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5x6KkpcZB3L0z3",
      "api_version" => "2015-02-18"
    }
  end

  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    kevin = Fabricate(:user, customer_token: "cus_5w8SSvTMaX0fkI")
    post "/stripe_events", event_data
    expect(kevin.reload).not_to be_active
  end
end