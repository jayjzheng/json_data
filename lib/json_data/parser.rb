require 'json'

module JSONData
  class Parser
    def parse(raw_json)
      raw_json.is_a?(String) ? JSON.parse(raw_json) : raw_json
    end
  end
end
