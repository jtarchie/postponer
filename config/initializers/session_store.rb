# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_postponer_session',
  :secret      => '9b6bbe14ad8254f9a27ec7c596e662f4154f0eb2e297559f4507841f8b3226546743b1ef3484f9f90d82fd77e7aa77a8220003ed651fa1d8f35b2dc2f7e1fd4e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
