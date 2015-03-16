require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "a vlaid charge"
        )

        expect(response.successful?).to be_truthy
      end

      it "makes a card declined charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "an invlaid charge"
        )

        expect(response.successful?).to be_falsy
      end

      it "returns the error ,essage for declined charges", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 3,
            :exp_year => 2018,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          source: token,
          description: "an invlaid charge"
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end