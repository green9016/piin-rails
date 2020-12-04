class CreatePinCatalogs < SeedMigration::Migration
  def up
    PinCatalog.create!(
      title: 'Home Pin',
      description: 'Initial Pin',
      remote_banner_url: 'https://via.placeholder.com/318x159/6B7A8F/FFFFFF?text=Home',
      icon: File.open(Rails.root.join('spec/support/blue-pin.png')),
      color: 'blue',
      miles: 10,
      range: 5,
      duration_in_days: 31,
      daily_price_in_cents: 100,
      status: :active
    )

    PinCatalog.create!(
      title: 'Blue Pin',
      description: 'This is the Blue pin',
      remote_banner_url: 'https://via.placeholder.com/318x159/005B96/FFFFFF?text=Blue',
      icon: File.open(Rails.root.join('spec/support/blue-pin.png')),
      color: 'blue',
      miles: 10,
      range: 5,
      duration_in_days: 31,
      daily_price_in_cents: 100,
      status: :active
    )

    PinCatalog.create!(
      title: 'Red Pin',
      description: 'This is the Red pin',
      remote_banner_url: 'https://via.placeholder.com/318x159/851E3E/FFFFFF?text=Red',
      icon: File.open(Rails.root.join('spec/support/red-pin.png')),
      color: 'red',
      miles: 20,
      range: 15,
      duration_in_days: 31,
      daily_price_in_cents: 500,
      status: :inactive
    )
  end

  def down; end
end
