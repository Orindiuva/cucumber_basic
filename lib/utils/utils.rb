class Util
  def self.get_array_of_hashes(table)
    array_of_hashes = []
    table.hashes.each do |param|
      array_of_hashes << param
    end
    data = array_of_hashes.map(&:to_a).flatten(1).reduce({}) { |h, (k, v)| (h[k] ||= []) << v; h }
    return data
  end

  def self.get_current_timestamp()
    now = Time.now
    #now = now.strftime("%Y-%m-%dT%H:%M:%S")
    #now = now.strftime('%Y%m%d%H%M%S')
    now = now.strftime('%Y%m')
    return now
  end

end
