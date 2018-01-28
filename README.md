![Universa](https://github.com/OpenSeltcana/universa_core/raw/staging/doc/logo.png)
=========
Universa is a Multi User Dungeon codebase written in Elixir, designed for scalability and extensiblity.

**NOTE:** Currently Universa is in its early design phase which entails it is unstable, likely to change and feature incomplete.

Table of Contents
-----------------

*   [Design](#design)
*   [Running](#running)
    *   [Exceptions](#exceptions)
*   [Contributing](#contributing)

Design
------

Currently I envision Universa as two supervisors: One supervisor for `Universa.Matter` responsible for loading locations and processing events as they relate to that location. Another supervisor for `Universa.Network` responsible for allowing players to connect and interact with the locations.

Upon connecting and authenticating, the process locates which node runs the `Universa.Location` responsible for the location the player is currently in. Then sends an event to that process to create a new entity (our player) and we add a `Universa.Matter.Entity.Component.Listener` to it. Whenever something happens in the Location, all listener components are sent a message. This way the player would get a reply to whatever command they input.

This also means that whenever a player moves from one location to another, they remove their entity from one `Universa.Location` and create a new `Universa.Location` at the new location, which could be running on an entirely different node.

This way we can achieve load balancing and a distributed setup. However wether this approach is crash-tolerant needs to be investigated.

Running
-------

Universa can be easily launched by cloning this repository and running mix.

```sh
git clone -b staging https://github.com/OpenSeltcana/universa
cd universa
iex -S mix
```

### Exceptions

If any tests fail it is likely you are running a different Erlang or Elixir version, currently the `elixir --version` on the build system returns:

```
Erlang/OTP 20 [erts-9.2] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10]

Elixir 1.5.3
```

Contributing
------------

Before pushing new code, make sure to lint your code first using the following commands:

```sh
mix deps.get # Only needs to be run once
mix credo --strict
```

After the linter passes you are free to push the code to the repository using:

```sh
git commit -a
git push
```

If you dont have write access you are always welcome to add your suggestions using the [awesome GitHub Issues tracker](https://github.com/OpenSeltcana/universa/issues)!
