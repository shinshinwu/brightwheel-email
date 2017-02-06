require 'rails_helper'

describe ApplicationController do
  describe 'POST send_email' do

    context 'when params are invalid' do
      it 'raises authentication error when it should' do
        post :send_email
        expect(JSON.parse(response.body)["errors"]["code"]).to eq("authentication_error")
      end

      it 'missing fields error when it should' do
        post :send_email, token: "yeswearebright"
        expect(JSON.parse(response.body)["errors"]["code"]).to eq("missing_fields")
      end

      it 'raises invalid email error when it should' do
        post :send_email, params: {token: "yeswearebright", to_name: "testuser", to: "invalidemail@@", from: "support@brightwheel.com", from_name: "brightwheel", subject: "hello", body: "test test"}
        expect(JSON.parse(response.body)["errors"]["code"]).to eq("invalid_email")
      end
    end

    context 'when params are valid' do
      it 'process mail through mailer' do
        post :send_email, params: {token: "yeswearebright", to_name: "testuser", to: "validemail@gmail.com", from: "support@mybrightwheel.com", from_name: "brightwheel", subject: "hello", body: "test test"}
        expect(JSON.parse(response.body)["success"]).to be true
      end
    end

  end
end
