module Helper
  def file_fixture(name)
    Pathname.new(fixtures_path(name))
  end

  def fixtures_path(name)
    File.join("spec/fixtures", name)
  end
end
