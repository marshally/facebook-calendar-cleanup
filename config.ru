require 'rubygems'
require 'bundler'

Bundler.require

get %r{\/clean\/(.+)} do
	url = "#{params[:captures].first}"
	puts "ohai"
	puts url
	puts request.query_string
	url.gsub!(/.*webcal\:\/+/, "http://")
	puts url
	contents = HTTParty.get(url, query: request.query_string).body

	contents.split("\r\n").map{|line|
		line.
			gsub(/([^\\])(,)/, '\1\\,').                                  # clean up commas
			gsub(/(DTSTART)\:(\d\d\d\d\d\d\d\d)\z/, '\1;VALUE=DATE:\2').  # clean up dates
			gsub(/(DTEND)\:(\d\d\d\d\d\d\d\d)\z/, '\1;VALUE=DATE:\2')     # clean up dates
			# gsub(/([^:])(\/+)/, '\1\\/')   # clean up stray back slashes
	}.join "\r\n"
end
