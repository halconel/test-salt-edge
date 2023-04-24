# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  let(:model) { described_class }

  describe 'the model' do
    subject(:the_model) { described_class }

    it { is_expected.to respond_to(:column_names, :create!, :reflections) }
  end

  describe '.column_names' do
    subject(:column_names) { described_class.column_names }

    describe 'result' do
      subject(:result) { column_names }

      it { is_expected.to be_an(Array) }

      columns = %w[
        id
        email
        encrypted_password
        reset_password_token
        reset_password_sent_at
        remember_created_at
        created_at
        updated_at
      ]
      it { is_expected.to match_array(columns) }
    end
  end

  describe '.create!' do
    subject(:create!) { described_class.create!(params) }

    let(:params) { attributes_for(:user, traits).except(*absent) }
    let(:traits) { {} }
    let(:absent) { [] }

    describe 'result' do
      subject(:result) { create! }

      it { is_expected.to be_a(described_class) }

      context 'when `created_at` is `nil`' do
        let(:traits) { { created_at: nil } }

        it 'creates record with default `created_at`' do
          expect(result.created_at).to be_within(1).of(Time.current)
        end
      end

      context 'when `created_at` is an empty string' do
        let(:traits) { { created_at: '' } }

        it 'creates record with default `created_at`' do
          expect(result.created_at).to be_within(1).of(Time.current)
        end
      end

      context 'when `updated_at` is `nil`' do
        let(:traits) { { updated_at: nil } }

        it 'creates record with default `updated_at`' do
          expect(result.updated_at).to be_within(1).of(Time.current)
        end
      end

      context 'when `updated_at` is an empty string' do
        let(:traits) { { updated_at: '' } }

        it 'creates record with default `updated_at`' do
          expect(result.updated_at).to be_within(1).of(Time.current)
        end
      end
    end

    context 'when `email` is absent' do
      let(:absent) { :email }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when `email` is `nil`' do
      let(:traits) { { email: nil } }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when `email` is an empty string' do
      let(:traits) { { email: '' } }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when `password` is absent' do
      let(:absent) { :password }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when `password` is `nil`' do
      let(:traits) { { password: nil } }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when `password` is an empty string' do
      let(:traits) { { password: '' } }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end

    context 'when there is user with such email already' do
      let(:traits) { { email: other_user_email } }

      let(:other_user)       { create(:user) }
      let(:other_user_email) { other_user.email }

      include_examples 'error raising', ActiveRecord::RecordInvalid
    end
  end

  describe '.reflections' do
    subject(:reflections) { described_class.reflections }

    describe 'result' do
      subject(:result) { reflections }

      it { is_expected.to be_a(Hash) }

      describe 'keys' do
        subject(:keys) { result.keys }

        it { is_expected.to match_array %w[] }
      end
    end
  end

  describe 'instance' do
    subject(:instance) { create(:user) }

    messages = %i[
      id
      email
      encrypted_password
      reset_password_token
      reset_password_sent_at
      remember_created_at
      created_at
      updated_at
      update!
      destroy!
    ]
    it { is_expected.to respond_to(*messages) }
  end

  describe '#id' do
    subject(:id) { instance.id }

    let(:instance) { create(:user) }

    describe 'result' do
      subject(:result) { id }

      it { is_expected.to be_a(Integer) }
    end
  end

  describe '#created_at' do
    subject(:created_at) { instance.created_at }

    let(:instance) { create(:user) }

    describe 'result' do
      subject(:result) { created_at }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#updated_at' do
    subject(:updated_at) { instance.updated_at }

    let(:instance) { create(:user) }

    describe 'result' do
      subject(:result) { updated_at }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#destroy!' do
    subject(:destroy!) { instance.destroy! }

    let(:instance) { create(:user) }

    it 'deletes the record' do
      id = instance.id
      destroy!

      expect(described_class.find_by(id:)).to be_nil
    end
  end
end
# rubocop:enable Metrics/BlockLength
