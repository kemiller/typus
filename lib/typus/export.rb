module Typus

  module Export

  protected

    def generate_csv

      require 'fastercsv'

      fields = @resource[:class].typus_fields_for(:csv).collect { |i| i.first }
      csv_string = FasterCSV.generate do |csv|
        csv << fields
        @items.items.each do |item|
          tmp = []
          fields.each { |f| tmp << item.send(f) }
          csv << tmp
        end
      end

      filename = "#{Time.now.strftime("%Y%m%d")}_#{@resource[:table_name]}.csv"
      send_data(csv_string,
               :type => 'text/csv; charset=utf-8; header=present',
               :filename => filename)

    rescue LoadError
      render :text => "FasterCSV is not installed."
    end

  end

end