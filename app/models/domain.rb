class Domain < ApplicationRecord
  has_many :certificates
  has_many :people
end
