require "sqlite3"
require "rulers/sqlite_model"

class MyTable < Rulers::Model::SQLite; end
STDERR.puts MyTable.schema.inspect

# Create row
mt = MyTable.create "title" => "It happened!", "posted" => 1, "body" => "It did!"
mt = MyTable.create "title" => "I saw it!"
mt = MyTable.create "title" => "I saw it again!"
mt["title"] = "I really did!"
mt.save!

puts "Count: #{MyTable.count}"

top_id = mt["id"].to_i
(1..top_id).each do |id|
  mt_id = MyTable.find(id)
  puts "Found title #{mt_id["title"]}."
end
 puts 'title with dot ' + mt.title.inspect
 puts 'posted with dot ' + mt.posted.inspect
