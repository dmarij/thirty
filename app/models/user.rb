class User < ActiveRecord::Base
  has_many :challenges, dependent: :destroy
  has_many :notes, dependent: :destroy
	rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :set_defaults
  private
  	def set_defaults
  		self.roles << Role.find_by_name(:user)
      self.notes_order = 'desc'
      self.notes_order_inline = 'desc'
  	end
end
