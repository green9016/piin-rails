SeedMigration.config do |c|
  c.migrations_path = File.join("data", "development") if Rails.env.development?
  c.migrations_path = File.join("data", "test")        if Rails.env.test?
  c.migrations_path = File.join("data", "production")  if Rails.env.production?
end