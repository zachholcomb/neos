require_relative 'near_earth_objects'

class NearEarthObjectsInterface < NearEarthObjects
  def self.start
    opening_sequence
    @@date ||= gets.chomp
    @@astroid_details = NearEarthObjects.find_neos_by_date(@@date)
    output
  end

  def self.opening_sequence
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"
  end

  def self.list_of_astroids
    @@astroid_details[:astroid_list]
  end

  def self.total_number_of_astroids
    @@astroid_details[:total_number_of_astroids]
  end

  def self.largest_astroid
     @@astroid_details[:biggest_astroid]
  end

  def self.create_column_labels
    { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
  end

  def self.create_column_data
    create_column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [list_of_astroids.map { |astroid| astroid[col].size }.max, label.size].max}
    end
  end

  def self.create_header
    "| #{ create_column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def self.create_divider
    "+-#{create_column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def self.format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def self.create_rows(astroid_data, column_info)
    astroid_data.each { |astroid| format_row_data(astroid, column_info) }
  end

  def self.format_date
    DateTime.parse(@@date).strftime("%A %b %d, %Y")
  end
   
  def self.output
    puts "______________________________________________________________________________"
    puts "On #{format_date}, there were #{total_number_of_astroids} objects that almost collided with the earth."
    puts "The largest of these was #{largest_astroid} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    puts create_divider
    puts create_header
    create_rows(list_of_astroids, create_column_data)
    puts create_divider
  end
end