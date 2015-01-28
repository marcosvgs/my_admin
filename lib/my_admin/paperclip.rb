Dir.glob(File.join( File.dirname(__FILE__) , "paperclip_processors", "*.rb")).each do |processor|
  require processor
end

