defmodule Universa.Core.System.MOTD do
  use Universa.Core.System

  subscribe "input"

  def handle(entity_uuid, "input", :component_create) do
    Universa.Core.Network.Connection.send(entity_uuid, """
\x1B[33m      .-  _             _  -.\r
     /   /  .         .  \\   \\ \x1B[35m    .   .     o\r
\x1B[33m    (   (  (  \x1B[36m (-o-) \x1B[33m  )  )   ) \x1B[35m   |   |,---...    ,,---.,---.,---.,---.\r
\x1B[33m     \\   \\_ ` \x1B[36m  |x|\x1B[33m   ` _/   /  \x1B[35m   |   ||   || \\  / |---'|    `---.,---|\r
\x1B[33m      `-      \x1B[36m  |x|\x1B[33m        -`   \x1B[35m   `---'`   '`  `'  `---'`    `---'`---^\r
              \x1B[36m  |x|\x1B[39m\r
\r
    Enter your nickname:\r
""")
  end
end
