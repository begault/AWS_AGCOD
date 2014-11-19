require 'spec_helper'
require 'aws_agcod'
require 'aws_agcod/gift_card'
require 'aws_agcod/transaction'
require 'aws_agcod/authentication_credentials'
require 'cgi'

describe AwsAgcod, :vcr => {:cassette_name => 'AwsAgcodCassette', match_requests_on: [:method, :uri, :aws_agcod_matcher]} do

  let(:config) {
    {access_key: 'random_access_key',
     secret_key: 'random_secret_key',
     partner_id: 'partner_id',
     country: 'GB',
     region: 'eu-west-1',
    host_url: 'https://agcod-v2-eu-gamma.amazon.com'}
  }
  let(:credentials) { AwsAgcod::AuthenticationCredentials.new(config) }

  describe 'GiftCard' do
    describe 'Create' do

      let(:request_id) { '123456987' }
      let(:amount) { 1.0 }

      subject {
        AwsAgcod::GiftCard.new(credentials).create(request_id, amount)
      }

      it 'should return a successful response' do
        expect(subject[:code]).to eq 200
        expect(subject[:resp].keys).to include 'gcClaimCode'
        expect(subject[:resp].keys).to include 'gcId'
      end

      context 'Same request_id in another country' do
        let(:country) {'FR'}
        it 'should return a successful response' do
          expect(subject[:code]).to eq 200
          expect(subject[:resp]).to include 'gcClaimCode'
          expect(subject[:resp].keys).to include 'gcId'
        end
      end

      context 'amount is nil' do
        let(:amount) { nil }
        it 'should return an error' do
          expect(subject[:code]).to eq 400
          expect(subject[:resp]['Message']).to eq nil
        end
      end

      context 'amount is too high' do
        let(:amount) { 20000 }
        it 'should return an error' do
          expect(subject[:code]).to eq 400
          expect(subject[:resp]["errorType"]).to eq 'OperationNotPermitted'
        end
      end

      context 'amount is negative' do
        let(:amount) { -1.0 }
        it 'should return an error' do
          expect(subject[:code]).to eq 400
          expect(subject[:resp]['message']).to eq 'Amount must be larger than 0'
          expect(subject[:resp]['errorType']).to eq 'InvalidAmountValue'
        end
      end

      context 'request_id is nil' do
        # This means request_id = Ifguk for Amazon, so it works ..
        let(:request_id ) { nil }
        it 'should return a successful response' do
          expect(subject[:code]).to eq 200
          expect(subject[:resp].keys).to include 'gcClaimCode'
          expect(subject[:resp].keys).to include 'gcId'
        end
      end

      context 'request_id is too long' do
        let(:request_id) { '123456789123456789' }
        it 'should return an error' do
          expect(subject[:code]).to eq 400
          expect(subject[:resp]['message']).to eq 'Request Id Too Long, Max allowed length is 19'
          expect(subject[:resp]['errorType']).to eq 'RequestIdTooLong'
        end
      end

      context 'request_id is composed of invalid characters' do
        # Special characters are allowed for request id
        let(:request_id) { '1=!4&5*9-7}%' }
        it 'should return a successful response' do
          expect(subject[:code]).to eq 200
          expect(subject[:resp].keys).to include 'gcClaimCode'
          expect(subject[:resp].keys).to include 'gcId'
        end
      end

      context 'Gift card has already been asked with another amount' do
        let(:amount) { 1.5 }
        it 'should return the original gift card' do
          expect(subject[:code]).to eq 200
          expect(subject[:resp]['cardInfo']['value']['amount']).to eq 1.0
        end
      end

    end

    describe 'Cancel' do

      let(:country) { 'FR' }
      let(:request_id) { '8794561264' }
      let(:gift_card_id) { 'A2GCN9BRX5QS76' }

      subject {
        AwsAgcod::GiftCard.new(credentials).cancel(request_id, gift_card_id)
      }

      context 'The gift card does not exist' do
        it 'should return a succesful response' do
          expect(subject[:code]).to eq 400
          expect(subject[:resp]['errorType']).to eq'OperationNotPermitted'
          expect(subject[:resp]['message']).to eq 'Operation Not Permitted'
        end
      end

      context 'The gift card exists' do
        let(:request_id) { 'CHIYP' }
        let(:amount) { 1.0 }
        let(:gift_card_creation) { AwsAgcod::GiftCard.new(credentials).create(request_id, amount) }
        let(:gift_card_id) {gift_card_creation[:resp]['gcId']}

        it 'should return a succesful response' do
          expect(subject[:code]).to eq 200
          expect(subject[:resp]['status']).to eq 'SUCCESS'
        end
      end

    end
  end

  describe 'Transaction' do
    describe 'GetActivityPage' do

      let(:country) { 'GB' }
      let(:request_id) { '123456987' }
      let(:start_date) { DateTime.parse('2014-09-01') }
      let(:end_date) { DateTime.parse('2014-09-30') }

      subject {
        AwsAgcod::Transaction.new(credentials).get_activity_page(request_id, start_date, end_date)
      }

      it 'should return a succesful response' do
        expect(subject[:code]).to eq 200
        expect(subject[:resp]['status']).to eq 'SUCCESS'
      end

    end
  end
end