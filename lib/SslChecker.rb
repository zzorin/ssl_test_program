class SslChecker
  def initialize(domain)
    @domain = domain
  end

  def check
    puts @domain.name
    uri = URI::HTTPS.build(host: @domain.name)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    cert = nil
    http.start do |h|
      cert = h.peer_cert
    end
    puts cert.not_after
    if Time.now + 2.weeks > cert.not_after
      @domain.set_expired!
    elsif Time.now + 1.weeks > cert.not_after
      @domain.set_expired!
    elsif Time.now > cert.not_after
      @domain.set_expired!
    else
      @domain.set_working!
    end
  end
end
