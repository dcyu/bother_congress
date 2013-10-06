class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.where(:in_office => 1)
                              .paginate(page: params[:page], per_page: 8)
  end
end