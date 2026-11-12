# Equipment

Level 0 values from the [registry](../src/reg/Registry.as#L122). Price is the rounded level 0 purchase price before trade-in. Cap is the normal upgrade limit. Unlock conditions are in each linked entry.

Weight curve is (zero-mass power ratio, cutoff mass, half-power step). Fuel is the raw amount. Standard stages and boosts burn one unit per unit of delta. Some items use these fields for their own effects. A dash marks a field with no registry value or applicable default. Empty slots use the default weight of 0. Pixels has 2 boost slots at level 0 because its slot count uses the first breakpoint, at level 2. [Price rounding](../src/reg/StatNice.as#L21) · [Default weight](../src/reg/RegistryEntry.as#L36) · [Slot lookup](../src/reg/StatFlat.as#L17)

[Flight formulas](mechanics.md) | [Equipment level curves](item-levels.md) | [Upgrades](upgrades.md)

## Bodies

| Item | Registry ID | Cap | Price | Weight | Top speed | Torque | Stage slots | Boost slots |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Empty](../src/reg/Registry.as#L134) | `emptyBody` | 0 | 0 | 3 | 6 | 0.15 | 1 | 1 |
| [Omega Penguin](../src/reg/Registry.as#L177) | `omegaPenguin` | 10 | 20 | 3 | 10 | 0.15 | 1 | 1 |
| [Crate](../src/reg/Registry.as#L216) | `crate` | 4 | 20 | 5 | 8 | 0.15 | 2 | 1 |
| [Trash Can](../src/reg/Registry.as#L262) | `trashCan` | 4 | 12 | 4 | 8 | 0.15 | 1 | 2 |
| [Glider](../src/reg/Registry.as#L308) | `glider` | 8 | 35 | 4 | 10 | 0.2 | 1 | 1 |
| [Jet](../src/reg/Registry.as#L357) | `jet` | 8 | 750 | 15 | 18 | 0.18 | 2 | 3 |
| [Pixels](../src/reg/Registry.as#L400) | `inlineBody` | 10 | 500 | 10 | 15 | 0.17 | 2 | 2 |
| [Thonderburd 1](../src/reg/Registry.as#L445) | `thunderbird` | 8 | 1000 | 20 | 20 | 0.17 | 3 | 2 |
| [The Bullet](../src/reg/Registry.as#L487) | `bullet` | 4 | 1000 | 30 | 30 | 0.025 | 3 | 0 |
| [Spearhead](../src/reg/Registry.as#L529) | `spearhead` | 4 | 600 | 15 | 25 | 0.002 | 1 | 0 |
| [Space Shuttle](../src/reg/Registry.as#L575) | `shuttle` | 10 | 3500 | 40 | 20 | 0.08 | 4 | 3 |
| [Omega Shuttle](../src/reg/Registry.as#L624) | `omegaShuttle` | 10 | 50000 | 60 | 50 | 0.12 | 4 | 4 |
| [Dodo](../src/reg/Registry.as#L655) | `dodo` | 10 | 40 | 8 | 12 | 0.04 | 0 | 0 |
| [Hedgehog Suit](../src/reg/Registry.as#L695) | `hedgehog` | 10 | 100 | 5 | 8 | 0.2 | 1 | 1 |
| [Rocket Kit](../src/reg/Registry.as#L747) | `rocketKit` | 8 | 450 | 10 | 12 | 0.15 | 0 | 2 |
| [Big B.I.R.D.](../src/reg/Registry.as#L823) | `bigBird` | 10 | 5000 | 250 | 15 | 0.02 | 0 | 0 |
| [Beer Keg](../src/reg/Registry.as#L904) | `beerKeg` | 8 | 650 | 18 | 12 | 0.15 | 2 | 2 |
| [Jetpack](../src/reg/Registry.as#L970) | `rocketeer` | 10 | 1000 | 10 | 8 | 0.3 | 0 | 2 |
| [Hero Costume](../src/reg/Registry.as#L1047) | `superman` | 10 | 4000 | 10 | 18 | 0.45 | 0 | 0 |
| [Capt. Supporter](../src/reg/Registry.as#L1129) | `captainSupporter` | 10 | 3000 | 10 | 15 | 0.45 | 0 | 0 |
| [Ejector Seat](../src/reg/Registry.as#L1206) | `ejector` | 4 | 160 | 8 | 14 | 0.1 | 2 | 1 |
| [Escape Pod](../src/reg/Registry.as#L1251) | `escapePod` | 5 | 2000 | 14 | 20 | 0.1 | 1 | 2 |
| [El Fuego!](../src/reg/Registry.as#L1320) | `elFuego` | 5 | 1000 | 12 | 15 | 0.1 | 2 | 2 |
| [Volcano](../src/reg/Registry.as#L1371) | `volcano` | 10 | 1300 | 35 | 30 | 0.15 | 2 | 1 |

## Launchers

| Item | Registry ID | Cap | Price | Power | Fuel | Weight curve | Stage slots | Boost slots |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Empty](../src/reg/Registry.as#L150) | `emptyLauncher` | 0 | 0 | - | - | - | - | 0 |
| [Coil](../src/reg/Registry.as#L1427) | `coil` | 6 | 10 | 170 | - | (1.5, 10, 15) | - | 2 |
| [Launch Pad](../src/reg/Registry.as#L1457) | `launchPad` | 8 | 2500 | 0 | 1.25 | (1, 0, 0) | - | 0 |
| [Omega Coil](../src/reg/Registry.as#L1491) | `omegaCoil` | 10 | 50000 | 13000 | - | (1.4, 250, 250) | - | 2 |
| [Explosives](../src/reg/Registry.as#L1517) | `explosive` | 8 | 800 | 950 | - | (1.45, 15, 15) | - | 2 |
| [Nuclear Reactor](../src/reg/Registry.as#L1549) | `nuclearReactor` | 10 | 5000 | 2600 | - | (1.5, 40, 40) | - | 2 |
| [Tilt Cannon](../src/reg/Registry.as#L1581) | `tiltCannon` | 8 | 80 | 300 | - | (1.5, 15, 30) | - | 0 |
| [Big Bertha](../src/reg/Registry.as#L1614) | `bigBertha` | 10 | 5500 | 2500 | - | (1.45, 50, 20) | - | 0 |
| [Slingshot](../src/reg/Registry.as#L1652) | `slingshot` | 6 | 40 | 450 | - | (1.45, 15, 15) | - | 2 |
| [Catapult](../src/reg/Registry.as#L1686) | `catapult` | 8 | 600 | 700 | - | (1.45, 30, 30) | - | 2 |
| ["Kick" Starter](../src/reg/Registry.as#L1720) | `kickstarter` | 8 | 600 | 1200 | - | (1.4, 30, 40) | - | 0 |
| [Powder Cannon](../src/reg/Registry.as#L1749) | `cannonPowder` | 10 | 1000 | 1200 | - | (1.4, 15, 15) | - | 2 |
| [Steamshot](../src/reg/Registry.as#L1782) | `steamLauncher` | 10 | 1600 | 1900 | - | (1.4, 40, 40) | - | 2 |
| [Grenade](../src/reg/Registry.as#L1818) | `grenade` | 8 | 280 | 720 | - | (1.45, 30, 30) | - | 0 |
| [Bazooka](../src/reg/Registry.as#L1854) | `bazooka` | 10 | 1900 | 2200 | - | (1.45, 35, 35) | - | 0 |
| [Russian Roulette](../src/reg/Registry.as#L1892) | `russianRoulette` | 10 | 350 | 777 | - | (1.45, 25, 25) | 1 | 2 |
| [Alien Bait](../src/reg/Registry.as#L1935) | `ufo` | 10 | 4500 | 9 | 200 | (1, 50, 50) | - | 0 |
| [Orbital Cannon](../src/reg/Registry.as#L1987) | `orbital` | 10 | 5000 | 3150 | - | (1.4, 60, 60) | - | 0 |

## Boosts

| Item | Registry ID | Cap | Price | Power | Fuel | Weight | Weight curve | Special |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Empty](../src/reg/Registry.as#L154) | `emptyBoost` | 0 | 0 | - | - | 0 | - | - |
| [Auxiliary Rockets](../src/reg/Registry.as#L2032) | `auxiliaryRocket` | 4 | 20 | 1 | 300 | 1 | (1.35, 15, 8) | - |
| [Cash Drive](../src/reg/Registry.as#L2076) | `cashDrive` | 10 | 25 | 1.2 | 300 | 1 | (1.35, 15, 8) | 0.9 |
| [Pressurized gas](../src/reg/Registry.as#L2125) | `gasCan` | 6 | 30 | 1.6 | 150 | 2 | (1.35, 12, 8) | - |
| [Propellers](../src/reg/Registry.as#L2166) | `propellerBoost` | 4 | 50 | 0.8 | 600 | 1 | (1.35, 10, 10) | - |
| [Multi Rockets](../src/reg/Registry.as#L2213) | `multiRocket` | 10 | 600 | 1.35 | 120 | 2 | (1.35, 30, 40) | - |
| [Multi Jumps](../src/reg/Registry.as#L2283) | `multiJump` | 10 | 1250 | 25 | 5 | 3 | (1.35, 30, 40) | 25 |
| [Rocket Boost](../src/reg/Registry.as#L2326) | `rocketBoost` | 10 | 2500 | 1.1 | 1000 | 2 | (1.4, 40, 30) | - |
| [F1 Bell Nozzle](../src/reg/Registry.as#L2368) | `bellNozzle` | 10 | 4500 | 3 | 400 | 8 | (1.4, 65, 40) | - |
| [Omega Boosters](../src/reg/Registry.as#L2410) | `omegaBoosters` | 10 | 50000 | 8 | 800 | 10 | (1.35, 200, 200) | - |
| [Mini Helpers](../src/reg/Registry.as#L2448) | `miniHelpers` | 10 | 250 | 3 | 250 | 0 | (1.2, 40, 50) | - |
| [Bug-Drive](../src/reg/Registry.as#L2489) | `recurringBoost` | 10 | 900 | 0.5 | 150 | 1 | (1.35, 15, 25) | 0.2 |
| [Steam Booster](../src/reg/Registry.as#L2543) | `steamBoost` | 10 | 1250 | 8 | 600 | 4 | (1.35, 40, 30) | - |
| [Fins](../src/reg/Registry.as#L2586) | `fins` | 10 | 50 | 0.9 | 1 | 3 | - | - |
| [Spin Booster](../src/reg/Registry.as#L2626) | `spinBooster` | 10 | 50 | 0.05 | 800 | 1 | (1, 20, 60) | - |
| [Dodgers](../src/reg/Registry.as#L2667) | `dodgers` | 10 | 100 | 3 | 300 | 1 | (1.55, 30, 40) | - |
| [The Brick](../src/reg/Registry.as#L2710) | `brickBoost` | 10 | 10 | 0 | 1 | 1 | (1, 1, 1) | 225 |
| [The Omega Brick](../src/reg/Registry.as#L2752) | `omegaBrick` | 10 | 10000 | 666 | 1000 | 50 | (1, 1, 1) | 225 |
| [Pingu Balloon](../src/reg/Registry.as#L2787) | `balloonBoost` | 10 | 5 | 0 | 1 | -1 | (1, 1, 1) | 225 |
| [Fuel Canister](../src/reg/Registry.as#L2822) | `extraFuel` | 10 | 150 | 0.15 | - | 15 | - | - |
| [Repeller](../src/reg/Registry.as#L2848) | `shield` | 10 | 230 | 0.9 | - | 4 | - | - |
| [Shields](../src/reg/Registry.as#L2873) | `energyShield` | 10 | 350 | 1 | 10 | 12 | - | - |
| [Money Turbine](../src/reg/Registry.as#L2906) | `moneyTurbine` | 10 | 400 | 1 | - | 4 | - | - |
| [Dark Matter](../src/reg/Registry.as#L2936) | `negativeMass` | 10 | 800 | 0.9 | - | 2 | - | 0.5 |

## Stages

| Item | Registry ID | Cap | Price | Power | Fuel | Weight | Weight curve | Special |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Empty](../src/reg/Registry.as#L157) | `emptyStage` | 0 | 0 | - | - | 0 | - | - |
| [Balloon](../src/reg/Registry.as#L2977) | `balloon` | 4 | 5 | 1.25 | 90 | 0.1 | (1.35, 6, 6) | - |
| [Rodeo](../src/reg/Registry.as#L3019) | `rodeo` | 10 | 1000 | 7 | 425 | 0.1 | (1.3, 40, 20) | 0.9 |
| [Omega Balloon](../src/reg/Registry.as#L3071) | `omegaBalloon` | 10 | 100000 | 6 | 2000 | 0.5 | (1.35, 50, 50) | - |
| [Omega Rocket](../src/reg/Registry.as#L3109) | `omegaRocket` | 10 | 100000 | 5 | 3200 | 0.5 | (1.35, 120, 120) | - |
| [Balloon Array](../src/reg/Registry.as#L3147) | `balloonArray` | 10 | 15 | 2.2 | 90 | 2 | (1.35, 16, 16) | - |
| [Tater Reactor](../src/reg/Registry.as#L3185) | `potatoStage` | 8 | 200 | 2 | 350 | 2 | (1.35, 30, 30) | - |
| [Rocket](../src/reg/Registry.as#L3222) | `rocket` | 6 | 90 | 1.65 | 325 | 2 | (1.35, 10, 10) | - |
| [The DIY](../src/reg/Registry.as#L3264) | `diy` | 8 | 90 | 2.5 | 325 | 2 | (1.35, 20, 20) | - |
| [Vector](../src/reg/Registry.as#L3316) | `vector` | 8 | 2500 | 1.8 | 550 | 20 | (1.35, 40, 30) | - |
| [Monster Engine](../src/reg/Registry.as#L3362) | `monsterTruck` | 10 | 2650 | 8 | 280 | 20 | (1.35, 150, 150) | - |
| [Torpedo](../src/reg/Registry.as#L3407) | `torpedo` | 10 | 5000 | 5.5 | 550 | 12 | (1.65, 30, 30) | - |
| [Cruise Missile](../src/reg/Registry.as#L3451) | `cruiseMissile` | 10 | 5500 | 4 | 600 | 15 | (1.35, 60, 50) | - |
| [Shuttle Reactor](../src/reg/Registry.as#L3488) | `shuttleReactor` | 10 | 6000 | 2.6 | 1400 | 25 | (1.1, 70, 60) | - |
| [RC Helicopter](../src/reg/Registry.as#L3530) | `rcCopter` | 4 | 15 | 1 | 400 | 0.5 | (1.2, 8, 8) | - |
| [Banshee](../src/reg/Registry.as#L3578) | `banshee` | 10 | 1750 | 1.4 | 1400 | 4 | (1.5, 20, 20) | - |
| [Fireworks](../src/reg/Registry.as#L3624) | `firework` | 6 | 75 | 1.75 | 220 | 0.8 | (1.6, 10, 10) | 100 |
| [RPG](../src/reg/Registry.as#L3673) | `rpg` | 8 | 600 | 4 | 180 | 4 | (1.6, 20, 20) | 150 |
| [Pulse Jet](../src/reg/Registry.as#L3721) | `pulseJet` | 8 | 400 | 1.75 | 800 | 3.5 | (1.45, 15, 15) | 0.7 |
| [Ram Jet](../src/reg/Registry.as#L3767) | `ramJet` | 10 | 3500 | 3 | 900 | 7.5 | (1.4, 30, 25) | 0.35 |
| [Sonic Burst](../src/reg/Registry.as#L3814) | `sonicBurst` | 10 | 400 | 325/6 | 6 | 4 | (1.99, 30, 25) | - |
| [Sonic Drive](../src/reg/Registry.as#L3859) | `sonicDrive` | 10 | 2400 | 255 | 5 | 6 | (1.8, 70, 65) | - |
| [Dubstep Drive](../src/reg/Registry.as#L3921) | `dubstepDrive` | 10 | 2800 | 15 | 800 | 10 | (1.9, 40, 35) | - |
| [Solar Turbine](../src/reg/Registry.as#L3957) | `solar` | 10 | 1400 | 1.2 | 2000 | 1 | (1.35, 30, 30) | 150000 |

## Body stages

| Item | Registry ID | Cap | Power | Fuel | Weight | Weight curve | Special |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [rocketKitStage](../src/reg/Registry.as#L801) | `rocketKitStage` | 8 | 3 | 600 | 0 | (1.05, 20, 30) | - |
| [bigBirdStage](../src/reg/Registry.as#L882) | `bigBirdStage` | 10 | 3 | 2000 | 0 | (1.25, 350, 350) | - |
| [beerKegStage](../src/reg/Registry.as#L951) | `beerKegStage` | 8 | 4 | 100 | 0 | (1.2, 50, 50) | - |
| [rocketeerStage](../src/reg/Registry.as#L1024) | `rocketeerStage` | 10 | 5 | 1000 | 0 | (1, 20, 20) | - |
| [supermanStage](../src/reg/Registry.as#L1108) | `supermanStage` | 10 | 30 | 1600 | 0 | (1.15, 30, 35) | 0.94 |
| [captainSupporterStage](../src/reg/Registry.as#L1185) | `captainSupporterStage` | 10 | 25 | 1800 | 0 | (1.2, 20, 35) | 0.94 |
| [escapePodStage](../src/reg/Registry.as#L1298) | `escapePodStage` | 5 | 4 | 350 | 0 | (1.35, 30, 30) | - |
