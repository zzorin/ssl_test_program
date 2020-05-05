class SslChecker
  def initialize(domain)
    @domain = domain
  end

  def check
    puts @domain.name
    uri = URI::HTTPS.build(host: @domain.name)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    cert = nil
    begin
      http.start do |h|
        cert = h.peer_cert
        if Time.now + 2.weeks > cert.not_after
          @domain.two_weeks_to_expired!
        elsif Time.now + 1.weeks > cert.not_after
          @domain.one_week_to_expired!
        else
          @domain.set_working!
        end
      end
    rescue OpenSSL::SSL::SSLError => e
      puts e
      @domain.set_ssl_error!
    rescue
      @domain.set_another_error!
    end
  end
end
