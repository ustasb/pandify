Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'swf')
Rails.application.config.assets.precompile += %w(*.swf)
