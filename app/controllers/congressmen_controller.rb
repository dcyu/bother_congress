class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 4)
  end

  def search
    results = Congressman.where("in_office = 1 AND firstname || ' ' || lastname ~* ?", "[[:<:]]"+params[:q])

    if request.xhr?
      return render :json => results[0..3].to_json(:only => [:title, :firstname, :lastname, :party, :state], :methods => [:picture_url])
    else
      @congressmen = results.paginate(page: params[:page], per_page: 4)

      render :action => 'index'
    end
  end

  def names
    render :json => Congressman.where(in_office: 1).select([:firstname, :lastname]).all.map(&:fullname)
  end
end