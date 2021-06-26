{ lib }:
{
  ifttt = cond: ifTrue: ifFalse:
    if cond
    then ifTrue
    else ifFalse;
}