class Domain < ApplicationRecord
  has_many :certificates
  belongs_to :person
end
