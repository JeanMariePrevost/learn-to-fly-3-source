# Learn to Fly 3: source code

The ActionScript 3 code of Learn to Fly 3, the Steam version.

This is an edited snapshot of the Flash source. We removed platform integrations and cleaned up the scripts that called them. The gameplay guides on `main` point to the retained mechanics and formulas.

This is for reading, not building. The art, sound, Flash project file and third-party libraries aren't included.

## Versions

1. `main`: the latest version.
2. Tag [`2018-steam-release`](../../tree/2018-steam-release): the 2018 Steam release.

Both snapshots report `1.2.13`. Gameplay differs, so cite the tag or commit when comparing speedrun results. [Compare them](../../compare/2018-steam-release...main).

## What's here

1. `src/`: the game's classes. Most of the flight is in `src/game`, and item, upgrade and stat definitions are in `src/reg/Registry.as`.
2. `scripts/`: the code that sat on timeline frames inside the Flash project file, one file per timeline. Each block starts with a comment saying which layer and frame it's on.
3. `framework/lbg/`: Light Bringer Games' shared Flash library, which the game uses for logging, saving, anti-cheat values and more.

Not included, since they aren't ours to relicense: Nape (physics), FRESteamWorks, as3corelib, as3crypto, and the other third-party Flash libraries the framework used.

A few framework files are other people's code, and keep their own licenses: `CollisionDetection.as` (Grant Skinner, MIT), `MouseWheelTrap.as` (spikything.com, MIT), `Easing.as` (Robert Penner, BSD), and `BigInt.as` (Leemon Baird, ActionScript port by Ian Peters, public domain).

## License

The [LBG-NCNC License v1.0](LICENSE.md) covers Light Bringer Games' source code in this repository.

You can read, use, change, and share the code for noncommercial purposes, including by forking it on GitHub. When sharing, credit Light Bringer Games and keep the license and copyright notices. Get written permission before distributing or hosting a product based on the code that competes with or undercuts a Light Bringer Games product or service, even if it's free. The full license governs.

Light Bringer Games reserves its rights in the game's name, art, and sound. Third-party files have their own licenses.
