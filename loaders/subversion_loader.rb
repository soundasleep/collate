module SubversionLoader
  def load_subversion
    puts "Checking out latest subversion #{subversion} into #{workspace}..."
    passthru "svn checkout #{subversion} #{workspace}"
  end
end
