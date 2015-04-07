require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/slack_lingr_gateway_handler"

Lita::Handlers::SlackLingrGatewayHandler.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
