class Contact < ApplicationRecord
  belongs_to :user
  has_many :contact_infos
end
