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
		if line.include?("ORGANIZER") || line.include?("SUMMARY")
			line.gsub!('"', '')
			line.gsub!('\\', '')
			line.gsub!('\/', '')
		end

		line.gsub!(/([^\\])(,)/, '\1\\,')                                  # clean up commas
		line.gsub!(/(DTSTART)\:(\d\d\d\d\d\d\d\d)\z/, '\1;VALUE=DATE:\2')  # clean up dates
		line.gsub!(/(DTEND)\:(\d\d\d\d\d\d\d\d)\z/, '\1;VALUE=DATE:\2')    # clean up dates
		line
	}.join "\r\n"
end
