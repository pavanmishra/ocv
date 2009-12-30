# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ocv_session',
  :secret      => '4da621624af6e6b1ead32927322211969458f7514fd0f50f53c8be80593d40712e0190a5b1f64a5c1a92ff8056c18d33483643ad5367b9e385fc3af13bc67e15'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
