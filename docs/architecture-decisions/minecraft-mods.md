# Minecraft Mods

Date: 2022-07-04

## Status

Partially completed.

## Context

Choosing which mods to use for Minecraft.

## Decision

I went ahead and refer to [alkyaly]'s [Performance Mods][performance-mods].

## Consequences

As a result, my choices of mods for server-side and client-side are solely based on the performance improvement column within it.

- One of my friends has a crappy Chromebook that barely has 4GB of RAM available. He could benefit from any optimization mods, so with FerriteCore, LazyDFU, CullLeaves, and Sodium enabled he was able to achieve more than _unknown_ FPS than before (Chromebook doesn't even have F3 button, and mods showing FPS requires Fabric API).

His impression was very much positive as it was much more responsive than before. Definitely a must-have for clients running on old hardware.

- Paper didn't allow me to install Fabric Loader, so it was kind of a miss, but [Starlight][starlight] came around and I really wanted to try it out. Luckily, there is a Paper fork called [Tuinity][tuinity], and it includes a lot of performance patches, _including_ a patch that uses Starlight.

- I would very much stay far away from Fabric API, as my friend's FPS dropped significantly when having that mod, and after I accidently recommended him to install it :v

- Starlight should be a must-have on servers considering how impactful it is on server resources. I run MC server on a Raspberry Pi 4 with 2GB of RAM, and total usage never goes over 90% even with multiplayer enabled (around 4-9 players).

[alkyaly]: https://github.com/alkyaly
[performance-mods]: https://gist.github.com/alkyaly/02830c560d15256855bc529e1e232e88
[starlight]: https://github.com/PaperMC/Starlight
[tuinity]: https://github.com/Tuinity/Tuinity
