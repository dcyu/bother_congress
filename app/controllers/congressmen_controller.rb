class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.where(:in_office => 1, :has_picture => true).paginate(page: params[:page], per_page: 4)
  end

  def search
    results = Congressman.where("in_office = 1 AND firstname || ' ' || lastname ~* ?", "[[:<:]]"+params[:q].strip)

    if request.xhr?
      congressmen = results[0..3].map do |c|
        {
          id: c.id,
          title: c.title,
          firstname: c.firstname,
          lastname: c.lastname,
          party: c.party,
          state: c.state,
          picture_url: c.picture_url,
          selected: !!session[:congressmen].try(:include?, c.id)
        }
      end
      render :json => congressmen.to_json
    else
      @congressmen = results.paginate(page: params[:page], per_page: 4)

      render :action => 'index'
    end
  end

  def add_recipient
    session[:congressmen] = [] unless session[:congressmen]

    if session[:congressmen].size < 3
      session[:congressmen] << params[:id].to_i
      session[:congressmen].uniq!
    end

    render :json => Congressman.find_all_by_id(session[:congressmen]).to_json(:only => :id, :methods => [:fullname, :picture_url])
  end

  def remove_recipient
    session[:congressmen].try(:delete, params[:id].to_i)
    render :json => session[:congressmen], :status => 200
  end
end