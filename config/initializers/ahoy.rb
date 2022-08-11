class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false


# Set the duration (Default is 4 hours)
Ahoy.visit_duration = 30.minutes

# Track visit from multiple subdomains
Ahoy.cookie_domain = :all
Ahoy.cookie_options = {same_site: :lax}