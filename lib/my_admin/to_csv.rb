class Array

  def to_csv(options = {})
    options.reverse_merge!(:header => true)

    csv_data = CSV.generate do |csv|

      if options[:header]
        csv << options[:header_columns]
        self.each do |model|
          row = []
          options[:only].each do |column|
            row.push(model.send(column.to_s))
          end
          csv << row
        end
      end
      
    end
    return csv_data
  end

end