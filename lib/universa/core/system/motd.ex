defmodule Universa.Core.System.MOTD do
  use Universa.Core.System

  subscribe "io"

  def handle(entity_uuid, "io", _value, :player_connect) do
    Universa.Core.EventSystem.event_custom(entity_uuid, "io", """
\x1B[33m      .-  _             _  -.\r
     /   /  .         .  \\   \\ \x1B[35m    .   .     o\r
\x1B[33m    (   (  (  \x1B[36m (-o-) \x1B[33m  )  )   ) \x1B[35m   |   |,---...    ,,---.,---.,---.,---.\r
\x1B[33m     \\   \\_ ` \x1B[36m  |x|\x1B[33m   ` _/   /  \x1B[35m   |   ||   || \\  / |---'|    `---.,---|\r
\x1B[33m      `-      \x1B[36m  |x|\x1B[33m        -`   \x1B[35m   `---'`   '`  `'  `---'`    `---'`---^\r
              \x1B[36m  |x|\x1B[39m\r
\r
    Enter your nickname:\r
""", :player_output)
  end
end
