class User < ApplicationRecord
  has_many :posts
  validates :email, :name, :auth_token, presence: true

  after_initialize :generate_auth_token

  def generate_auth_token
    return if auth_token.present?

    self.auth_token = TokenGeneratorService.generate!
  end
end
