module MercurialLoader
  def load_mercurial
    puts "Checking out latest Mercurial #{mercurial} into #{workspace}..."
    if File.exist?(workspace)
      passthru "cd #{workspace} && hg pull && hg update"
    else
      passthru "hg clone #{mercurial} #{workspace}"
    end
  end
end