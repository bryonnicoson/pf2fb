require 'bundler'
Bundler.require()

# get our petfinder xml 
@xml = HTTParty.get(ENV['PETFINDER_URI'])

# convert any breed Strings to Arrays
@xml["petfinder"]["pets"].each do |pet|
	i = 0
	length = pet[1].size

	while i < length
		breed = pet[1][i]["breeds"]["breed"]
		if breed.class == Strings
			arr = Array.new
			arr.push(breed)
			pet[1][i]["breeds"]["breed"] = arr
		end
		i += 1
	end
end

#firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_KEY'])
firebase = Firebase::Client.new(ENV['FIREBASE_URI'])
response = firebase.push('', @xml.to_json)

