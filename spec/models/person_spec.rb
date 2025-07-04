require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to have_many :domains }
end
