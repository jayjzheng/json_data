require 'json'

module JSONData
  class Handler
    def self.safe_parse(raw_json)
      raw_json.is_a?(String) ? JSON.parse(raw_json) : raw_json
    end
  end
end
