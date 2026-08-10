# frozen_string_literal: true

Rails.application.config.dartsass.builds = {
  'active_admin_dart.scss' => 'active_admin_dart.css'
}

Rails.application.config.dartsass.build_options = [
  '--style=compressed',
  '--no-source-map',
  '--quiet-deps',
  '--silence-deprecation=import',
  '--silence-deprecation=global-builtin',
  '--silence-deprecation=color-functions',
  '--silence-deprecation=slash-div'
]
