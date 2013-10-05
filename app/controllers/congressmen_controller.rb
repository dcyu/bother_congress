class CongressmenController < ApplicationController
  def index
    @congressmen = Congressman.all 
  end
end