[1;33mdiff --git a/app/assets/javascripts/congressmen-search.js.coffee b/app/assets/javascripts/congressmen-search.js.coffee[m
[1;33mindex 22b5f65..5867a1c 100644[m
[1;33m--- a/app/assets/javascripts/congressmen-search.js.coffee[m
[1;33m+++ b/app/assets/javascripts/congressmen-search.js.coffee[m
[1;35m@@ -35,8 +35,8 @@[m [m$ ->[m
   $(".overlay").on "click", (e) ->[m
     $.ajax[m
       type: "POST",[m
[1;31m-      url: '/congressmen/add_new',[m
[1;31m-      data: $(this).data('id'),[m
[1;32m+[m[1;32m      url: '/congressmen/add_recipient',[m
[1;32m+[m[1;32m      data: {id: $(this).data('id')},[m
       success: (data) ->[m
[1;31m-        console.log("Congressmen update succeeded" + data)[m
[1;32m+[m[1;32m        console.log(data)[m
 [m
[1;33mdiff --git a/app/controllers/congressmen_controller.rb b/app/controllers/congressmen_controller.rb[m
[1;33mindex 44bcd88..a3749b8 100644[m
[1;33m--- a/app/controllers/congressmen_controller.rb[m
[1;33m+++ b/app/controllers/congressmen_controller.rb[m
[1;35m@@ -20,7 +20,19 @@[m [mclass CongressmenController < ApplicationController[m
     render :json => Congressman.where(in_office: 1).select([:firstname, :lastname]).all.map(&:fullname)[m
   end[m
 [m
[1;31m-  def add_new[m
[1;32m+[m[1;32m  def add_recipient[m
[1;32m+[m[1;32m    session[:congressmen] = [] unless session[:congressmen][m
 [m
[1;32m+[m[1;32m    if session[:congressmen].size < 3[m
[1;32m+[m[1;32m      session[:congressmen] << params[:id][m
[1;32m+[m[1;32m      session[:congressmen].uniq![m
[1;32m+[m[1;32m    end[m
[1;32m+[m
[1;32m+[m[1;32m    render :json => session[:congressmen], :status => 200[m
[1;32m+[m[1;32m  end[m
[1;32m+[m
[1;32m+[m[1;32m  def remove_recipient[m
[1;32m+[m[1;32m    session[:congressmen].try(:delete, params[:id].to_i)[m
[1;32m+[m[1;32m    render :json => session[:congressmen], :status => 200[m
   end[m
 end[m
\ No newline at end of file[m
[1;33mdiff --git a/config/routes.rb b/config/routes.rb[m
[1;33mindex 46f6842..b72dac9 100644[m
[1;33m--- a/config/routes.rb[m
[1;33m+++ b/config/routes.rb[m
[1;35m@@ -4,7 +4,7 @@[m [mBotherCongress::Application.routes.draw do[m
   get "/congressmen", :to => "congressmen#index", :as => :congressmen[m
   get "congressmen/names"[m
   get "congressmen/search"[m
[1;31m-  post "congressmen/add_new"[m
[1;32m+[m[1;32m  post "congressmen/add_recipient"[m
 [m
   get "sessions/create"[m
 [m
