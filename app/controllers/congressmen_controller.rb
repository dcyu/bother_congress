class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 8)
  end

  def names
    render :json => Congressman.select([:firstname, :lastname]).all.map(&:fullname)
  end
end