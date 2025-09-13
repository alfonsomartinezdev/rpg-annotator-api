#  since we have no jobs atm, use main database for Solid Queue in all environments
Rails.application.configure do
  config.solid_queue.connects_to = {
    database: { writing: :primary, reading: :primary }
  }
end
