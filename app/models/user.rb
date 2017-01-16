class User < ApplicationRecord
  before_create :skip_confirmation!

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oauth(auth)
    return nil if auth.blank? || auth.provider.blank? || auth.uid.blank?

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email].blank? ? get_email(auth) : auth.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.get_email(auth)
    "temp_#{auth.uid}@#{auth.provider}.com"
  end

  def is_subscribed(question)
    subscriptions.where(question: question).exists?
  end
end
