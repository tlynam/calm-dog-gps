class RaspberryPisController < ApplicationController
  def edit
    raspberry_pi
  end

  def update
    if raspberry_pi.update_attributes(raspberry_pi_params)
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
end
