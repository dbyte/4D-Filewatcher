# Introduction
Filewatcher-4D is a proof of concept which demonstrates the interaction of 4D.SystemWorker, the 4D statement
CALL WORKER and a platform-native backend (developed with Rust, safe and highly performant).
Neither 4D plugins or components need to be used, nor any other runtime engines.
It also demonstrates the possibility to run the above processes completely in the background while not blocking
views and the main loop but still update relevant objects in views (or any other application context) live.

## Usage
In 4D compiled mode, the app starts immediately with a Monitor view. In 4D interpreted mode, you'll have to run
the "launch" Method. The monitoring of a selectable directory can be toggled via the Start/Stop button.
The Filewatcher settings can only be changed when monitoring is stopped. It can be restarted afterwards.

## Some details about design of the 4D app
It should not be a big problem to extract only the backend functionality. The class
for the main view controller provides a kind of API for the Filewatcher even without a view. Also, all other
classes have been designed in such a way that they can be easily incorporated into existing projects, possibly
as 4D components as well.

## Some details about the backend
The monitoring on the part of the backend is currently throttled (a.k.a. bounced) to 1 second, because
the changes, even with nested directories with ~70.000 files, are so fast that they would be recorded
up to 3 times for the same file with different Git events (delete, create, modify) in case you monitor a
Git repo.