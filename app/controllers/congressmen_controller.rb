class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 4)
  end

  def search
    results = Congressman.where("in_office = 1 AND firstname || ' ' || lastname ~* ?", "[[:<:]]"+params[:q].strip)

    if request.xhr?
      return render :json => results[0..3].to_json(
        :only => [:id, :title, :firstname, :lastname, :party, :state], :methods => [:picture_url])
    else
      @congressmen = results.paginate(page: params[:page], per_page: 4)

      render :action => 'index'
    end
  end

  def names
    render :json => Congressman.where(in_office: 1).select([:firstname, :lastname]).all.map(&:fullname)
  end

  def add_recipient
    session[:congressmen] = [] unless session[:congressmen]

    if session[:congressmen].size < 3
      session[:congressmen] << params[:id]
      session[:congressmen].uniq!
    end

    render :json => session[:congressmen], :status => 200
  end

  def remove_recipient
    session[:congressmen].try(:delete, params[:id].to_i)
    render :json => session[:congressmen], :status => 200
  end
end