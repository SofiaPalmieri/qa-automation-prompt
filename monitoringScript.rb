require 'net/http'
require 'sqlite3'
require 'json'

# Connect to SQLite database and create table if it doesn't exist
db = SQLite3::Database.new("request_logs.db")
db.results_as_hash = true

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS request_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    url TEXT NOT NULL,
    name_parameter TEXT NOT NULL,
    response_status INTEGER NOT NULL,
    response_text TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL

url = URI("https://qa-challenge-nine.vercel.app/api/name-checker")

file_path = "names.txt" 
if !File.exist?(file_path)
  puts "Error: The file #{file_path} does not exist."
  exit
end

names = File.readlines(file_path, chomp: true) 
if names.empty?
  puts "Error: The file #{file_path} is empty."
  exit
end

puts "Monitoring API for 10 minutes. Press Ctrl+C to stop."

start_time = Time.now

names.each do |name|
  if Time.now - start_time > 600 
    puts "10 minutes are over. Exiting..."
    break
  end

  request_start_time = Time.now
  request = Net::HTTP::Get.new(url)
  request["Content-Type"] = "application/json"
  request.body = { name: name }.to_json

  begin
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == "https") do |http|
      http.request(request)
    end

    response_time = Time.now - request_start_time
    status_code = response.code.to_i
    response_body = response.body

    puts "Response for #{name}: Status=#{status_code}, Body=#{response_body}, Response Time=#{response_time.round(2)}s"

    if status_code == 200
      puts "Request was successful for #{name}."
    else
      puts "Request failed for #{name} with status code: #{status_code}"
    end

    retries = 3
    success = false
    begin
      db.execute("INSERT INTO request_logs (url, name_parameter, response_status, response_text) 
                  VALUES (?, ?, ?, ?)", 
                 [url.to_s, name, status_code, response_body])
      success = true
    rescue SQLite3::BusyException => e
      retries -= 1
      if retries > 0
        puts "Database is locked, retrying... (#{retries} retries left)"
        sleep(1)
      else
        puts "Error: Database is still locked after retries. Skipping request."
        success = false
      end
    end

    if success
      puts "Logged: Name=#{name}, Status=#{status_code}, Response Time=#{response_time.round(2)}s"
    end

  rescue => e
    puts "Error: #{e.message}"
  end

  sleep(1)
end
