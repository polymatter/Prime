class Player < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  has_many :units
  
  def is_human?
    is_human
  end
  
  def is_computer?
    !is_human
  end
end
