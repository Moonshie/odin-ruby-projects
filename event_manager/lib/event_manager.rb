require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_pnumber(phone_number)
  if phone_number.length == 11 && phone_number[0] == '1'
    phone_number.slice(1..)
  elsif phone_number.length > 10 || phone_number.length < 10
    ' '
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  Dir.mkdir('output/letters') unless Dir.exist?('output/letters')
  filename = "output/letters/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def form_thank_you_letters(contents)
  template_letter = File.read('form_letter.erb')
  erb_template = ERB.new template_letter
  contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    legislators = legislators_by_zipcode(zipcode)
    form_letter = erb_template.result(binding)
    save_thank_you_letter(id, form_letter)
  end
end

def form_phone_numbers_list(contents)
  Dir.mkdir('output') unless Dir.exist?('output')
  File.open('output/phone_numbers.txt', 'w') do |f|
    contents.each do |row|
      name = row[:first_name]
      phone_number = row[:homephone].tr('^0-9', '')
      phone_number = clean_pnumber(phone_number) if phone_number.length != 10
      f.puts("#{name} - #{phone_number}")
    end
  end
end

def find_peak_hours(contents)
  hours = []
  contents.each do |row|
    hours << row[:regdate].slice(-5..-4)
  end
  top_3_hours = hours.tally.sort_by(&:last).reverse[0..2]
  puts 'Top 3 hours of registration:'
  puts "#{top_3_hours[0][0]}:00 (#{top_3_hours[0][1]} people registered)"
  puts "#{top_3_hours[1][0]}:00 (#{top_3_hours[1][1]} people registered)"
  puts "#{top_3_hours[2][0]}:00 (#{top_3_hours[2][1]} people registered)"
end

def list_functions
  puts 'What would you like to do?'
  puts '1. Form "Thank You" letters'
  puts '2. Form Phone Numbers list'
  puts '3. Find peak registration hours'
end

def function_select(contents)
  list_functions
  function = gets.chomp
  case function
  when '1'
    puts 'Forming "Thank You" letters now.'
    form_thank_you_letters(contents)
    puts 'All done! You can find them in ./output/letters/'
  when '2'
    puts 'Forming Phone Numbers list now.'
    form_phone_numbers_list(contents)
    puts 'All done! You can find it in ./output/'
  when '3'
    puts 'Finding peak registration hours now.'
    find_peak_hours(contents)
    puts 'All done!'
  else
    puts 'Error: incorrect input. Input the number of needed function.'
    function_select(contents)
  end
end

puts 'Event Manager Initialized!'

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

function_select(contents)
