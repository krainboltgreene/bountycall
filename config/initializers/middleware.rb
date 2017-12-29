BlankWebRails::Application.config.middleware.use(Rack::Deflater)
BlankWebRails::Application.config.middleware.use(Rack::Attack)
