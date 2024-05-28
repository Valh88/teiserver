import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :teiserver, TeiserverWeb.Endpoint,
  url: [host: "yourdomain.com"],
  https: [
    port: 8888,
    otp_app: :teiserver,
    ciphers: [
      'ECDHE-ECDSA-AES256-GCM-SHA384',
      'ECDHE-RSA-AES256-GCM-SHA384',
      'ECDHE-ECDSA-AES256-SHA384',
      'ECDHE-RSA-AES256-SHA384',
      'ECDHE-ECDSA-DES-CBC3-SHA',
      'ECDH-ECDSA-AES256-GCM-SHA384',
      'ECDH-RSA-AES256-GCM-SHA384',
      'ECDH-ECDSA-AES256-SHA384',
      'ECDH-RSA-AES256-SHA384',
      'DHE-DSS-AES256-GCM-SHA384',
      'DHE-DSS-AES256-SHA256',
      'AES256-GCM-SHA384',
      'AES256-SHA256',
      'ECDHE-ECDSA-AES128-GCM-SHA256',
      'ECDHE-RSA-AES128-GCM-SHA256',
      'ECDHE-ECDSA-AES128-SHA256',
      'ECDHE-RSA-AES128-SHA256',
      'ECDH-ECDSA-AES128-GCM-SHA256',
      'ECDH-RSA-AES128-GCM-SHA256',
      'ECDH-ECDSA-AES128-SHA256',
      'ECDH-RSA-AES128-SHA256',
      'DHE-DSS-AES128-GCM-SHA256',
      'DHE-DSS-AES128-SHA256',
      'AES128-GCM-SHA256',
      'AES128-SHA256',
      'ECDHE-ECDSA-AES256-SHA',
      'ECDHE-RSA-AES256-SHA',
      'DHE-DSS-AES256-SHA',
      'ECDH-ECDSA-AES256-SHA',
      'ECDH-RSA-AES256-SHA',
      'AES256-SHA',
      'ECDHE-ECDSA-AES128-SHA',
      'ECDHE-RSA-AES128-SHA',
      'DHE-DSS-AES128-SHA',
      'ECDH-ECDSA-AES128-SHA',
      'ECDH-RSA-AES128-SHA',
      'AES128-SHA'
    ],
    secure_renegotiate: true,
    reuse_sessions: true,
    honor_cipher_order: true
  ],
  force_ssl: [hsts: true],
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  version: Mix.Project.config()[:version]
