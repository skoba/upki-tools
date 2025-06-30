require 'rails_helper'

RSpec.describe Domain, type: :model do
  it { is_expected.to have_many :person }
  it { is_expected.to have_many :certificates }
end
