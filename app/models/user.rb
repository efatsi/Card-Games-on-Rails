class User < ActiveRecord::Base

  include SimplestAuth::Model
  authenticate_by :username
  
  attr_accessible :username, :password, :password_confirmation
  
  has_many :players, :dependent => :destroy
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_confirmation_of :password, :if => :password_required?

  
end
