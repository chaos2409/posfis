class Manage::Product < ActiveRecord::Base
	has_many :orders
	has_attached_file :picture, {
    :styles => {
      :thumb => ["50x50#", :png],
      :medium => ["100x100#", :png],
      :large => ["300x300>", :png]
    },
    :default_url => "/assets/noimg.png"
  }
  include PublicActivity::Model

  tracked :owner => proc {|controller, model| controller.current_user}
end
