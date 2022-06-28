class Team < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  after_create do
    Apartment::Tenant.create(tenant_name)
  end

  after_destroy do
    Apartment::Tenant.drop(tenant_name)
  end
end
