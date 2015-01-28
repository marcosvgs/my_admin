Paperclip.options[:command_path] = "/opt/ImageMagick/bin/"

MyAdmin.setup do |config|
  config.title = "My Admin"
  config.url_prefix = "admin"
end

MyAdmin::Application.add([MyAdmin::Group, MyAdmin::Log, MyAdmin::User])