class CreateFirmReports < SeedMigration::Migration
  def up
    Firm.find_each do |firm|
      firm.firm_reports.create!
    end
  end

  def down

  end
end
