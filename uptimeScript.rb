require 'sqlite3'

db = SQLite3::Database.new("request_logs.db")

total_requests = db.get_first_value("SELECT COUNT(*) FROM request_logs").to_f
successful_requests = db.get_first_value("SELECT COUNT(*) FROM request_logs WHERE response_status = 200").to_f
uptime_percentage = (successful_requests / total_requests) * 100

puts "Total Requests: #{total_requests.to_i}"
puts "Successful Requests (200): #{successful_requests.to_i}"
puts "Service Uptime: #{uptime_percentage.round(2)}%"
