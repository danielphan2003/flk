{lib}: {
  ifttt = cond: ifTrue: ifFalse:
    if cond
    then ifTrue
    else ifFalse;

  mkSuite = suite: lib.flatten (builtins.attrValues suite);
}
