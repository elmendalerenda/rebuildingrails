require "multi_json"
module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def save
        self.class.save_to_file(@id, @hash)
      end

      class << self
        def method_missing(name, *args)
          attr_match = name.to_s.match(/^find_all_by_(.*)/)
          return super if attr_match.nil?
          attr = attr_match[1]
          all.select { |el| el[attr] == args[0] }
        end

        def all
          files = Dir["db/quotes/*.json"]
          files.map { |f| FileModel.new f }
        end

        def find(id)
          begin
            FileModel.new("db/quotes/#{id}.json")
          rescue
            return nil
          end
        end

        def create(attrs)
          hash = {}
          hash["submitter"] = attrs["submitter"] || ""
          hash["quote"] = attrs["quote"] || ""
          hash["attribution"] = attrs["attribution"] || ""
          files = Dir["db/quotes/*.json"]
          names = files.map { |f| f.split("/")[-1] }
          highest = names.map { |b| b.to_i }.max
          id = highest + 1
          save_to_file(id, hash)
          FileModel.new "db/quotes/#{id}.json"
        end

        def save_to_file(id, hash)
          File.open("db/quotes/#{id}.json", "w") do |f|
            f.write <<TEMPLATE
{
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
          end
        end
      end
    end
  end
end
