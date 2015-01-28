module MyAdmin
	class YMLManager

    def self.generate_yml directory, file
      @base_path = file
      @current_path = "#{directory}/#{file}" 
      
      @current = YAML.load(File.read( @current_path ))
      MyAdmin::YMLManager.merge
    end

		protected
			def self.merge
  			unless File.exists?(@base_path)
  				File.open(@base_path, "w") { |out| YAML.dump( YAML.load(File.read( @current_path) ) , out) }
  				puts "create " + @base_path
  			else
  				@base = YAML.load(File.read( @base_path )) || {}
  				@current = YAML.load(File.read( @current_path )) || {}


          MyAdmin::YMLManager.merge_packages @base, @current

  				File.open(@base_path, "w") { |out| YAML.dump(@base, out) }
  				puts "merge " + @base_path
  			end
  		end

  	  def self.merge_packages base, current
  	    if(base.class == Hash && current.class == Hash)
  	      current.each_key do |asset_type|
  	        if base.has_key?(asset_type)
  	          MyAdmin::YMLManager.merge_packages base[asset_type], current[asset_type]
	          else
	            base[asset_type] = current[asset_type]
            end
          end
  	    end
  	  end
	end
end
