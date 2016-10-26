use Mix.Config

config :papersist, elm_slack_irc_password: System.get_env("ELM_SLACK_IRC_PASSWORD")
config :papersist, :wordpress,
  access_token: System.get_env("WP_ACCESS_TOKEN"),
  site_id: System.get_env("WP_SITE_ID")
