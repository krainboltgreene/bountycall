Bountycall::Application.config.middleware.tap do |middleware|
  middleware.use(Rack::Deflater)
  middleware.use(Rack::Attack)
  # config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  #   rewrite   '/wiki/John_Trupiano',  '/john'
  #   r301      '/wiki/Yair_Flicker',   '/yair'
  #   r302      '/wiki/Greg_Jastrab',   '/greg'
  #   r301      %r{/wiki/(\w+)_\w+},    '/$1'
  # end
end
