class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :username, presence: :true, uniqueness: { case_sensitive: false }
  # Only allow letter, number, underscore and punctuation.
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_username

  def validate_username
    # Don't allow people to use email address as username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  # Allow users to login with email or username
  attr_accessor :login
  def login
    @login ||= self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["username = :value OR email = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      conditions[:username].downcase! if conditions[:username]
      where(conditions.to_h).first
    end
  end

  def jwt_payload
    # Add custom data to payload here
    super.merge({})
  end
end
