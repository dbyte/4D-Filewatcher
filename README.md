![owner](https://img.shields.io/badge/%C2%A9-knk%20Business%20Software%20AG-orange)
![licence](https://img.shields.io/badge/license-MIT-brightgreen)
![fourdVersion](https://img.shields.io/badge/4D%20compatibility-v19R6%2B-blue)

# Introduction
Filewatcher-4D is a proof of concept which demonstrates the interaction of `4D.SystemWorker`, the 4D statement
`CALL WORKER` and a platform-native backend (developed with Rust, especially for 4D project structures, safe and
highly performant).

Neither 4D plugins nor 4D components need to be used, nor any other runtimes or JIT compilers.

It also demonstrates the possibility to run the above processes completely async, avoiding blocking
views and the main loop, but still update relevant objects in your UI (or any other application context) live.

## The main use case
for the backend tool was to replace the 4D full text code-search with our own
4D introspection component by introducing a _customizable_ full text search over our 4D code.

## Usage
In 4D compiled mode, the app starts immediately with the "Monitor" view. In 4D interpreted mode, you'll have to run
the project method `launch`. The monitoring of a selectable directory can be toggled via the Start/Stop button.
The filewatcher settings can only be changed when monitoring is stopped. It can be restarted afterwards.

## Some details about design of the 4D app
It should be trivial to extract only the 4D filewatcher backend functionality. The class for the main view controller
provides a kind of API for the filewatcher service even without a view. Also, all other classes have been
designed in such a way that they can be easily incorporated into existing projects; possibly into 4D
components as well.

Also note there is an indicator for cooperative/preemptive mode in the UI. When running compiled, it should
switch to `preemptive` when the watcher is up.

The monitoring on the part of the backend is currently throttled (a.k.a. bounced) to 1 second by the 4D config
within the 4D `launch` project method, because the recorded changes, even with nested directories with ~70.000 files,
are so fast that they would be recorded up to 3 times for the same file with different Git events
(delete, create, modify) in case you monitor a Git repo. Anyway, this value is configurable.

## Some details about the backend
The backend is written in Rust. It is specialized for 4D application structures and performs at C++ speed.
Anyway, you may use it for any other needs.
To get some infos about this command line app, just run it natively in your terminal and apply argument
-h or --help.

We have implemented a cheap async stdin/stdout broker, so it is possible to communicate with the backend over
stdin while it is asynchronously streaming file system events to stdout. You may, at any time, pass the following
strings, **followed by a `newline` char**, to stdin:
- `version`: Writes the SemVer of the backend to stdout
- `teardown`: Initiates a graceful shutdown, which writes some additional feedback to stdout

### Excluded files and directories (hard coded defaults)
The following items are invisible for the backend watcher, using glob patterns. See
https://en.wikipedia.org/wiki/Glob_(programming) for an explanation what globbing means in the context of OS paths.
    
    "*.git*"

    // macOS Finder crap
    "*.DS_Store"
    
    // IntelliJ creates a temp file before it modifies it
    "*~"
    
    // 4D project stuff
    "**/DerivedData/*"
    "**/temporary files/*"
    "**/userPreferences.*/*"
    "**/Logs/*"
    "*.4DD"
    "*.4DIndx"
    "*.Match"
    "*.journal"
