
  require 'json'
  require_relative '../../utils/utils'
  require_relative '../../utils/https'
  class HSI_Request

    attr_accessor :json_request_payload
    attr_accessor :json_response_payload

    def initialize(template)
      file_path = ::File.join(Dir.pwd, 'resources', 'FTTH', "HSI", template)
      @json_request_payload = JSON.parse(::File.read(file_path))
    end

    # Generic deep_set supporting arrays with index, key=value, or append []
    def deep_set(path, value)
      parts = path.split('.')
      #current = obj
      current = self.json_request_payload
      parts.each_with_index do |part, idx|
        # Check for array patterns: [0], [], [key=value]
        if part =~ /(.*?)\[(.*?)\]/
          key_name = $1
          index = $2
          current = current[key_name] if !key_name.empty?
          current ||= []

          if index == ""
            # append
            if idx == parts.size - 1
              current << value
              return
            else
              current << {}
              current = current.last
            end
          elsif index =~ /^\d+$/
            i = index.to_i
            current[i] ||= {}
            current = current[i]
          elsif index =~ /(.*?)=(.*)/
            match_key, match_value = $1, $2
            found = current.find { |h| h[match_key] == match_value }
            unless found
              found = { match_key => match_value }
              current << found
            end
            current = found
          end
        else
          # Last key assignment
          if idx == parts.size - 1
            current[part] = value
          else
            current[part] ||= {}
            current = current[part]
          end
        end
      end
    end

    def set_dinamic_parameter(row, time)
      path = row["path"]

      if path.include?("relatedServiceIdentifier")
        row["value"] = "SI"+ time
      end
    end

    def http_request_call(end_point)
      url = "http://localhost:4567" + end_point
      headers= { "Content-Type" => "application/json" }
      self.json_response_payload = HTTPS.http_request_call_post(url, self.json_response_payload,headers)
     end

    def hsi_services(table,path, operacao, srv)
      if table and table.hashes[0]['path']
        time = Util.get_current_timestamp()
        #Adiciona parametros que nao estao presentes na feature
        #Adicionar uma data fixa
        table.hashes << {"path"=>"orderDate", "value"=>"2025-10-08T17:37:16"}
        table.hashes << {"path"=>"orderItem[0].action", "value"=>"#{operacao.downcase}"}
        table.hashes << {"path"=>"orderItem[0].serviceSpecification.id", "value"=>"CFS.#{srv}"}
        table.hashes << {"path"=>"orderItem[0].service.id", "value"=>"#{time}"}
        table.hashes << {"path"=>"orderItem[0].service.serviceCharacteristic[name=serviceIdentifier]", "value"=>"NA#{time}"}
        table.hashes.each do |row|
          self.set_dinamic_parameter(row, time)
          path_table = row['path']

          if path_table.match?(/name=.*?\]/)
            path_table += ".value"
          end

          value_table = row['value']
          parsed_value = JSON.parse(value_table) rescue value_table.to_s
          parsed_value = [] if parsed_value == "[]"
          self.deep_set(path_table, parsed_value)
        end
      elsif table == nil
          parsed_value = []
          path_table = "orderItem[0].service.place"
          self.deep_set(path_table, parsed_value)
      end

      self.http_request_call(path)
    end

  end

