class User < ActiveRecord::Base
  has_many :challenges, dependent: :destroy
	after_create :set_default_role
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  private
  	def set_default_role
  		self.roles << Role.find_by_name(:user)
  		self.save
  	end
end
