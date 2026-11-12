# Learn to Fly 3: source code

![Learn to Fly 3 cover art](docs/capsule.jpg)

ActionScript 3 source for Learn to Fly 3 version 1.2.13 (Steam build 2826715). Most of the code is in separate ActionScript classes. A smaller set of frame scripts inside Flash movie clips handles loading, interface elements, and animation.

I used scripts, AI agents and some manual edits to remove platform integrations, clean up the scripts that called them, and put together the docs. The guides link to the code so you can check the details yourself.

## Mechanics

The notes follow a flight from launch through stage and boost use to cash payout. They also cover equipment stats by level, upgrades, and game modes.

1. [Flight and payouts](docs/mechanics.md)
2. [Equipment stats](docs/items.md) and [level curves](docs/item-levels.md)
3. [Upgrades and Bonus Shop](docs/upgrades.md)
4. [Progression and game modes](docs/progression.md)

## Artwork renders

[Preview](docs/art-renders/preview.png) · [Asset manifest](docs/art-renders/manifest.csv). The full pack contains transparent 256 × 256 and 1024 × 1024 PNGs in `learn-to-fly-3-art-renders.zip` for [Releases](../../releases).

## What's here

This release is for reading the source. I left out the original art files, sound, Flash project file and third-party libraries.

1. `src/` holds the game's classes. Most of the flight code is in `src/game`. Item, upgrade and stat definitions are in `src/reg/Registry.as`.
2. `scripts/` holds the code from the Flash timelines, one file per timeline. Each block starts with a comment naming its layer and frame.
3. `framework/lbg/` holds Light Bringer Games' shared Flash utilities.

The game used Nape (physics), FRESteamWorks, as3corelib, as3crypto, and other third-party Flash libraries.

Several included framework files carry their own terms. `CollisionDetection.as` is by Grant Skinner (MIT), `Easing.as` is by Robert Penner (BSD), `BigInt.as` is by Leemon Baird with an ActionScript port by Ian Peters (public domain), and `MouseWheelTrap.as` is from spikything.com (MIT).

## License

This project is licensed under the [LBG-NCNC License v1.0](LICENSE.md).

**Short version:** Do whatever, but give credit, don’t make money from it, don’t compete with me, and don’t hurt my business. (See the license for the actual terms.)

Light Bringer Games reserves its rights in the game's name, art, and sound. Third-party files have their own licenses.
