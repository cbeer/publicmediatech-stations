# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sites_session',
  :secret      => 'c3d95a1dfec63cee0a17a0269ee74d0968b8967f73817dea3ac4b5f62fb89ae80174344286dc044b5e3d53aa151970a509aa755bccfc21da089bbcd1b38a22e6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
