class Request < ActiveRecord::Base
  REQUEST_TYPES = %w(Relaxation Adventure Exploration Romance)

  belongs_to :user
  accepts_nested_attributes_for :user
end
