namespace :server do
  desc "connect to remote server"
  task :connect do
    Kernel.system("ssh deploy@hedra.com.br")
  end

  desc "tail production log"
  task :log do
    Kernel.system("ssh deploy@hedra.com.br 'tail -f ~/apps/hedra-site/current/log/production.log'")
  end

  desc "returns a production console"
  task :console do
    Kernel.exec("ssh deploy@hedra.com.br  'cd ~/apps/hedra-site/current/; bundle exec rails c production'")
  end

  desc "updates XML sitemap"
  task :sitemap do
    Kernel.exec("ssh deploy@hedra.com.br 'cd ~/apps/hedra-site/current/; rake sitemap:refresh RAILS_ENV=production'")
  end

  desc "remakes search index and restarts Sphinx"
  task :search_rebuild do
    Kernel.exec("ssh deploy@hedra.com.br 'cd ~/apps/hedra-site/current/; rake ts:rebuild'")
  end
end
