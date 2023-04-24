# frozen_string_literal: true

RSpec.shared_examples 'error raising' do |error|
  it "raises `#{error}`" do
    expect { subject }.to raise_error(error)
  end
end
