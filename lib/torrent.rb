class Torrent
  def initialize(raw_hash)
    @raw_hash = raw_hash
    serialize.each do |k, v|
      instance_variable_set "@#{k}", v
      self.class.__send__(:attr_accessor, k)
    end
  end

  def serialize(pretty: false)
    Hash[
      @raw_hash.map do |k, v|
        [
          k,
          mutate(QUERIES[k][:kind], v, pretty: pretty)
        ]
      end
    ]
  end

  private

  def mutate(kase, data, pretty:)
    case kase
      when :file, :rate
        filesize = Filesize.from("#{data} B")
        pretty ? filesize.pretty : filesize
      when :date
        time = Time.at(data)
        pretty ? time.to_s : time
      when :ratio
        data.to_f / 1000
      when :bool
        !!data
      else
        data
    end
  end
end
