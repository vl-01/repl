module repl;
private {// import
  import std.stdio;
  import std.range;
  import std.string;
  import std.algorithm;
  import std.functional;
  import std.typetuple;
  import std.conv;
  import std.concurrency;
}

synchronized class Repl
{
  private string delegate(string[])[string] actions;

  void opIndexAssign(B, A...)(B delegate(A) action, string name)
  {
    actions[name] = (string[] argStrs)
    {
      if(argStrs.length != A.length)
        return text(
          name, " expects ", A.stringof,
          ", got (", argStrs.join(", "), ")"
        );

      A args;

      foreach(i,_; args)
        args[i] = argStrs[i].to!(A[i]);

      static if(is(B == void))
      {
        action(args);
        return "";
      }
      else
      {
        return action(args).text;
      }
    };
  }
  void opIndexAssign(typeof(null), string name)
  {
    actions.remove(name);
  }

  string read()
  {
    return stdin.readln!string;
  }
  string eval(string command)
  {
    auto cmd = command.split(" ").map!strip.filter!(not!empty);

    if(cmd.empty)
      return help;
    if(auto action = cmd.front in actions)
      try 
        return (*action)(cmd.dropOne.array);
      catch(Exception ex)
        return ex.msg;
    else
      return help;
  }
  void print(string result)
  {
    result.writeln;
  }
  void loop()
  {
    while(1)
      print(eval(read));
  }
  string help()
  {
    return text("commands: ", actions.keys.join(", "));
  }
}
