module Discotheque
  class Metadata

    attr_reader :instance_id, :image_id, :group_name, :availability_zone

    def initialize(mock=false)
      if mock == true
        @image_id = "ami-221fec4b"
        @group_name = "default"
        @availability_zone = "us-east-1a"
        return
      else
        base_url = "http://169.254.169.254/latest/meta-data/"
        begin
          %w[instance-id ami-id security-groups availability-zone].each do |datum|
            datum == "availability-zone" ? url="#{base_url}/placement/#{datum}" : url="#{base_url}#{datum}"
            d = HTTParty.get("#{url}").parsed_response
            if datum == "security-groups" 
              instance_variable_set "@group_name", d
            elsif datum == "ami-id"
              instance_variable_set "@image_id", d
            else
              instance_variable_set "@#{datum.gsub(/-/,"_")}", d
            end
          end
        rescue Errno::EHOSTUNREACH
          puts "This only makes sense on EC2 hosts"
        end
      end
    end

  end
end
