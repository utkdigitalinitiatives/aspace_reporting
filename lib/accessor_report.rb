require "mysql2"
require 'rubyXL'

class AccessorReport
  attr_accessor :sql_data, :excel_file
  attr_reader :root
  
  def initialize
    @root = File.expand_path('../..', __FILE__)
    @excel_file = "#{@root}/exports/aspace_accessions_report"
  end

  def sql_data=(value)
    if !value.is_a?(Array)
      abort 'data must be an array'
    end 
    @sql_data = value
  end

  def export_directory
    dir_name = "#{@root}/exports" 
    Dir.mkdir(dir_name) unless Dir.exists?(dir_name)
  end

  def create_workbook
    if File.exists?(@excel_file)
      @workbook = RubyXL::Parser.parse(@excel_file)
    else 
      @workbook = RubyXL::Workbook.new
    end 
  end

  def save_workbook
    if @workbook.nil?
      abort 'you must create a workbook before youc an save a workbook'
    end
    @workbook.write(@excel_file)
  end

  def write_to_workbook
    self.validate_workbook
    self.validate_sql_data
    self.set_worksheet

    sql_data.each_with_index do |row_data, row_number|
      @worksheet.change_row_height(row_number, 30)
      @worksheet.change_row_fill(row_number, 'eeeeee') if row_number.even?
      row_data.values.each_with_index do |cell_data, cell_number|
        @worksheet.insert_cell(row_number, cell_number, cell_data)
      end
    end
  end

  def write_headers
    self.validate_workbook
    self.validate_sql_data
    self.validate_worksheet
  
    @worksheet.insert_row(0)
    @worksheet.change_row_height(0, 30)
    
    headers = sql_data.first.keys
    headers.each_with_index do |value, col_number|
      @worksheet.insert_cell(0, col_number, "#{value}").change_font_color('ffffff')
      @worksheet.change_row_fill(0, '5aa4a3')
      @worksheet.sheet_data[0][col_number].change_vertical_alignment('center')
      @worksheet.change_row_vertical_alignment(0,'center')
    end
  end

  def set_worksheet(sheet_name = 'accessions')
    # changes name to remove default 
    @worksheet = @workbook[0];
    @worksheet.sheet_name = sheet_name
  end 

  def validate_workbook
     # validations
    if @workbook.nil?
      abort 'you must create a workbook before you can write to one'
    end
  end

  def validate_sql_data
    if sql_data.nil?
      abort 'you must have data before you can write the data'
    end
  end 

  def validate_worksheet
    if @worksheet.nil? 
      abort 'you must have a valid worksheet first'
    end 
  end 
end
