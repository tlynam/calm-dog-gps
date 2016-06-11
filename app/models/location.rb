require 'geokit'

class Location < ActiveRecord::Base
  belongs_to :raspberry_pi

  acts_as_mappable
end
