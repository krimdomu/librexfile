## A library to read Rexfiles

This is a library not intended for daily use. Use only if you're knowing what you're doing.

## USAGE

```perl
use strict;
use warnings;
use Rex::Rexfile;


my $f1 = Rex::Rexfile->new(file => "Rexfile");
my $tasks = $f1->get_tasks;

for my $task (@{ $tasks }) {
   print " - " . $task->name .  "\n";
}

$f1->run_task("foo");

$f1->run_task("foo", "server");
```
