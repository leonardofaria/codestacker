class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # :encryptable, encryptor: :restful_authentication_sha1,
         :authentication_keys => [:login]

	# Virtual attribute for authenticating by either username or email
	# This is in addition to a real persisted field like 'username'
	attr_accessor :login

  belongs_to :role
  before_create :set_default_role

	validates :username, :presence => true, :uniqueness => { :case_sensitive => false }

	def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
end
