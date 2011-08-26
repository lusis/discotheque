module Discotheque
  class Discover
    # NOTE
    # tags are not available via metadata calls
    # therefore tag will need to be an explcit value passed in
    # This actually makes sense if you want to discover a tag that isn't yours
    # Take the use case of a master/slave setup:
    # You would tag the master node with "foo_slave"
    # but you might need to find all slaves
    #
    VALID_FILTERS = %w[az sg tag ami arch]
    FILTER_MAP = {"az" => "availability-zone",
      "sg" => "group-name",
      "ami" => "image-id",
      "arch" => "architecture"}

    attr_accessor :filters

    def initialize(filters=[])
      @filters = filters
    end

    def get_nodes(creds={})
      # creds is a hash like so
      # creds = {:access_key_id => "YYYYYYYYYYYYYYYYYYYYYYYYYY", :secret_access_key => "XXXXXXXXXXXXX"}
      @filters.empty? ? f="ec2.instances" : f="ec2.instances.#{build_filter}"
      require 'aws-sdk'
      AWS.config creds
      ec2 = AWS::EC2.new
      candidates = AWS.memoize do
        ci = eval(f)
        ci.to_a.sort_by(&:ip_address).map {|i| i.ip_address}
      end
    end

    def clear_filters
      @filters = []
    end
    private
    def build_filter
      whoami = Metadata.new
      f = {}
      method_text = []
      @filters.each do |filter|
        next if (VALID_FILTERS.member?(filter) == false)
        f.merge!({"#{FILTER_MAP[filter]}" => whoami.instance_variable_get("@#{FILTER_MAP[filter].gsub(/-/,"_")}")})
      end
      f.each do |k,v|
        method_text << "filter('#{k}','#{v}')"
      end
      method_text.join('.')
    end
  end
end
