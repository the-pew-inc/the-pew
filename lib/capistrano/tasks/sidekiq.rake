namespace :sidekiq do
  after 'deploy:starting', 'sidekiq:stop'
  after 'deploy:finished', 'sidekiq:start'

  task :stop do
    on roles(:app) do
      within current_path do
        # execute(:sudo, 'systemctl kill -s TSTP sidekiq')
        execute(:sudo, 'systemctl stop sidekiq')
      end
    end
  end

  task :start do
    on roles(:app) do |host|
      execute(:sudo, 'systemctl start sidekiq')
      info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
    end
  end
end