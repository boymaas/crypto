class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  def crypto_trader_account
    @crypto_trader_account ||= CryptoTrader::Model::Account.find_or_create(:ext_crypto_user_id => self.id) do |account|
      account.label = email
    end
  end
end
