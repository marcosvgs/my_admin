class Array

  def to_csv(options = {})
    options.reverse_merge!(:header => true)

    csv_data = CSV.generate(:col_sep => ';') do |csv|

      if options[:header]
        csv << options[:header_columns]
        self.each do |model|
          row = []
          
          options[:only].each do |column|
            value = model.send(column.to_s)
            
            if value.class == Float
              value = ActionController::Base.helpers.number_with_delimiter(value, :delimiter => ".", :separator => ",")
            end

            row.push(value)
          end

          csv << row
        end
      end
      
    end
    return csv_data
  end

end