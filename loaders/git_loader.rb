module GitLoader
  def load_git
    puts "Checking out latest Git #{git} into #{workspace}..."
    if File.exist?(workspace)
      passthru "cd #{workspace} && git pull && git checkout master"
    else
      passthru "git clone --depth 1 #{git} #{workspace}"
    end
  end
end