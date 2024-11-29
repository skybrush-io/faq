## I am getting `No route to host` errors on the server console on macOS

This issue happens with macOS Sequoia or later _if_ you are using third-party
terminal applications (iTerm, `kitty` or similar) and you have not allowed your
terminal app to access the local network.

To fix this, go to *System Settings* > *Privacy & Security* > *Local Network*
and allow your terminal application to access the local network. You will need
to restart the terminal app after you have changed the setting.
