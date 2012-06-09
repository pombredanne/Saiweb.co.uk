require 'clouddns'

def get_stdin(msg)
    print msg
    STDIN.gets.chomp
end

dns = CloudDns::Client.new(
    :username   => get_stdin('What is your api username?: '),
    :api_key    => get_stdin('What is your api key?: '),
    :location   => :uk
)


for domain in dns.domains
    puts "--- " << domain.name
    for record in domain.records        
        print record
        puts ''
    end
end


