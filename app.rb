require 'bundler'
Bundler.require()

get '/' do
	petfinder_to_firebase
end


def petfinder_to_firebase()
	# get petfinder xml
	@xml = HTTParty.get(ENV['PETFINDER_URI'])	
	firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_KEY'])

	# for now, just wiping and refilling with all data
	response = firebase.delete("pets")
	
	# convert any breed Strings to Arrays
	@xml["petfinder"]["pets"].each do |pet|
		i = 0
		length = pet[1].size

		while i < length
			breed = pet[1][i]["breeds"]["breed"]
			if breed.class == String
				arr = Array.new
				arr.push(breed)
				pet[1][i]["breeds"]["breed"] = arr	
			end
			
			response = firebase.push("pets", {
					:name => pet[1][i]["name"],
					:size => pet[1][i]["size"],
					:age => pet[1][i]["age"],
					:sex => pet[1][i]["sex"],	
					:description => pet[1][i]["description"],
					:petfinder_id => pet[1][i]["id"]
					})
			i += 1
		end
	end

	# something to send to the screen to make the web server happy
	@xml.to_json

end