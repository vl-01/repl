# repl
read-eval-print-loop

Repl class is synchronized - once you go into a loop, you can't modify the repl bindings. Not sure if I want to go this way, long-term, but for now it will prevent some bugs.

```d
shared repl = new Repl;

repl["add"] = (int a, int b) => a + b;
repl["cat3"] = (string x) => x~x~x;

repl["jk"] = () => 0xDEADBEEF;
repl["jk"] = null;

repl.loop;
```

```
> hi
commands: cat3, add
> cat3
cat3 expects (string), got ()
> add
add expects (int, int), got ()
> add 5
add expects (int, int), got (5)
> add 5 10
15
> add 5 apple
Unexpected 'p' when converting from type string to type int
> cat3 9
999
> cat3 nine
nineninenine
```
