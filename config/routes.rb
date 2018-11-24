Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  namespace MyAdmin.url_prefix, :module => "my_admin" do

    root :to => "dashboards#index", :as => "root"

    resource :configuration, :only => [:update, :show]

    resource :first_user, :only => [:new, :create]

    resource :password, :only => [:edit, :update], :controller => "password"

    resource :sessions, :only => [:new, :create] do
      resources :recovers, :only => [:new, :create, :show, :update]


      collection do
        get :destroy
        get :lock
        get :unlock
        post :open
      end
    end

    MyAdmin::Application.items.each do |application|
      application.models.each_with_index do |model, index|
        scope model.my_admin.application_url do
          resources model.my_admin.url, :controller => model.tableize do

            collection do
              get :export
              post :remote
              post :destroy_all
              model.my_admin.collection.each do |type, name|
                send(type, name)
              end
            end

            member do
              model.my_admin.member.each do |type, name|
                send(type, name)
              end
            end

          end
        end
      end
    end

  end

end