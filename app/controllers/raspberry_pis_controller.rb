class RaspberryPisController < ApplicationController
  def edit
    raspberry_pi
  end

  def update
    if raspberry_pi.update_attributes(params_without_pw)
      redirect_to root_path, notice: "Raspberry Pi has been successfully updated"
    else
      flash[:alert] = 'Please Review the errors below'
      render :edit
    end
  end

  private

  def raspberry_pi
    @raspberry_pi ||= RaspberryPi.first
  end

  def raspberry_pi_params
    params.require(:raspberry_pi).permit(
      :name, :enabled, :volume, :duration, :audio_file_paths,
        phones_attributes: [
          :id, :_destroy, :icloud_device_name, :icloud_username, :icloud_password, :lat, :lng, :location_updated_at
        ],
        home_attributes: [
          :id, :_destroy, :type, :radius, :address
        ],
        exclusion_zones_attributes: [
          :id, :_destroy, :type, :radius, :address
        ]
    )
  end

  def params_without_pw
    non_phone_params = raspberry_pi_params.dup.except("phones_attributes")

    phone_params = raspberry_pi_params.dup["phones_attributes"]

    phone_params.each do |phone|
      phone[1].delete("icloud_password") if phone[1]["icloud_password"].blank?
    end

    non_phone_params.merge(phones_attributes: phone_params)
  end
end
