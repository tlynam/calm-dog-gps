require 'httparty'
require 'json'

class Phone < ActiveRecord::Base
  include HTTParty
  include Geokit::Geocoders

  belongs_to :raspberry_pi

  acts_as_mappable

  def self.update_locations!
    Phone.all.each do |phone|
      phone.update_location!
    end
  end

  def update_location!
    response = request :post, "fmipservice/client/web/initClient"

    devices = Hash[
      JSON.parse(response.body)["content"].collect do |device|
        [ device["name"], device["id"] ]
      end
    ]

    device_id = devices[icloud_device_name]

    response = request :post, "fmipservice/client/web/refreshClient",
      body: {
        device: device_id
      }.to_json

    location = response.parsed_response['content'].find do |content|
      content['name'] == icloud_device_name
    end or raise 'device not found'

    update_attributes!(
      lat: location['location']['latitude'],
      lng: location['location']['longitude'],
      location_updated_at: Time.current
    )
  end

  def near_home?
    phone_location = GoogleGeocoder.reverse_geocode([lat,lng])

    exclusion_flag = false

    raspberry_pi.exclusion_zones.each do |exclusion_zone|
      address = GoogleGeocoder.geocode(exclusion_zone.address)
      exclusion_flag = true if address.distance_to(phone_location) < exclusion_zone.radius
    end

    return false if exclusion_flag

    home_address = GoogleGeocoder.geocode(raspberry_pi.home.address)

    if home_address.distance_to(phone_location) < raspberry_pi.home.radius
      # If already home then don't trigger
      is_home? ? false : true
    else
      update_attribute(:is_home, false)
      false
    end
  end

  private

  def request(method, url, **args)
    unless @cookies
      @cookies = CookieHash.new

      response = HTTParty.post "https://setup.icloud.com/setup/ws/1/login",
        headers: {
          "Origin" => "https://www.icloud.com"
        },
        body: {
          apple_id: icloud_username,
          password: icloud_password
        }.to_json

      @url = JSON.parse(response.body)["webservices"]["findme"]["url"]

      @cookies.add_cookies(response.headers["Set-Cookie"])
    end

    args[:headers] = {
      "Origin" => "https://www.icloud.com",
      "Cookie" => @cookies.to_cookie_string
    }
    HTTParty.public_send method, "#{@url}/#{url}", **args
  end
end
