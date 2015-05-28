class Request < ActiveRecord::Base
  REQUEST_TYPES = %w(Relaxation Adventure Romance)

  validates :email, :destination, presence: true
end
