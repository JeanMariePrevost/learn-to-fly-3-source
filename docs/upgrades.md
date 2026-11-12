# Upgrades

## Equipment

- Buy at level 0. Upgrading from level `n` to `n + 1` costs the price at `n + 1`. Downgrading refunds the price at the current level. Replacing a part credits the sum paid from level 0 through its current level. [Price lookup](../src/system/GameStateItem.as#L41), [replacement](../src/shop/ShopEngine.as#L269), [upgrade](../src/shop/ShopEngine.as#L397), [refund](../src/shop/ShopEngine.as#L439)
- The normal cap is the item's registry `maxLevel`. Golden Wrench adds levels to bodies and launchers, Hammer to stages, Pliers to boosts, and Scope to Bonus Shop upgrades. Their power curves give 10 extra levels per tool level. The tools cap at level 3 and grant up to 30 extra levels. Their tables stop at the cap. [Cap lookup](../src/system/GameStateItem.as#L211), [tool curves](../src/reg/Registry.as#L4257)
- [Equipment level curves](item-levels.md) list the registry breakpoints. Prices use [StatNice](../src/reg/StatNice.as#L21). Values up to 10 round to two decimals, values under 100 to an integer, and values under 1000 to the nearest 10 after rounding to an integer. Larger values round to a place based on the integer's digit count, keeping three leading digits.

## Bonus Shop

Buy levels with Bonus Points. Lowering an adjustable upgrade gives no BP refund. Restoring a previously bought level is free. [Buying and restoring](../src/shop/bonusshop/BonusShopEngine.as#L194), [lowering levels](../src/shop/bonusshop/BonusShopEngine.as#L223)

Each curve shows `level:value`. An exponent follows in parentheses when it differs from 1. See [interpolation](item-levels.md) for the formula. The power column holds the configured effect value, usually a multiplier. [Modifier uses](../src/game/StatHooks.as#L74), [interest](../src/game/result/Result.as#L109)

The fuel field sets the Money Interest cash cap. For Secret Ingredient, it sets the launch buff duration to `fuel * 60` units of game delta. [Interest cap](../src/game/result/Result.as#L108), [launch buff](../src/game/gameobjects/player/launcher/AbstractLauncher.as#L100)

| Upgrade | Effect | Normal cap | BP price | Power | Fuel field |
| --- | --- | --- | --- | --- | --- |
| [Secret Ingredient](../src/reg/Registry.as#L4017) | Stage and boost power after launch | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.3, 2:1.4, 3:1.5, 33:1.75, 103:2 | 0:0, 1:5, 2:10, 3:15, 33:25, 103:40 |
| [Fuel Compression](../src/reg/Registry.as#L4044) | Boost fuel multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100, 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.5, 103:2.5 | - |
| [Potentiometer](../src/reg/Registry.as#L4064) | Boost power multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.5, 103:2.5 | - |
| [Fidelity Card](../src/reg/Registry.as#L4084) | BP per day | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 33:100, 103:100 | 0:0, 1:1, 2:2, 3:3, 13:4, 23:5, 33:6, 100:15 | - |
| [My lil black hole](../src/reg/Registry.as#L4108) | Gravity multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:0.98, 2:0.96, 3:0.94, 33:0.88, 100:0.7 | - |
| [Money Interest](../src/reg/Registry.as#L4129) | Daily interest rate | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:0, 1:0.01, 2:0.02, 3:0.03, 33:0.05, 103:0.15 | 0:5000, 1:6500, 2:8000, 3:10000, 33:15000, 103:100000 |
| [Premium Spring](../src/reg/Registry.as#L4157) | Launch power multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.1, 2:1.22, 3:1.35, 33:1.6, 103:3.2 | - |
| [Traffic Control](../src/reg/Registry.as#L4177) | Obstacle count multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:0.85, 2:0.7, 3:0.5, 33:0.35, 103:0.15 | - |
| [Aerodynamics](../src/reg/Registry.as#L4197) | Drag multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:0.95, 2:0.88, 3:0.8, 33:0.65, 103:0.5 | - |
| [Counter-winds](../src/reg/Registry.as#L4217) | Wind multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:100 | 0:1, 1:0.85, 2:0.7, 3:0.5, 33:0.25, 103:0.05 | - |
| [Boost Income](../src/reg/Registry.as#L4237) | Earnings multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.35, 103:2 | - |
| [The Golden Wrench](../src/reg/Registry.as#L4257) | Body and launcher over-levels | 3 | 0:0, 1:150, 2:200, 3:250 | 0:0, 3:30 | - |
| [The Golden Hammer](../src/reg/Registry.as#L4279) | Stage over-levels | 3 | 0:0, 1:150, 2:200, 3:250 | 0:0, 3:30 | - |
| [The Golden Pliers](../src/reg/Registry.as#L4301) | Boost over-levels | 3 | 0:0, 1:150, 2:200, 3:250 | 0:0, 3:30 | - |
| [The Golden Scope](../src/reg/Registry.as#L4323) | Bonus Shop over-levels | 3 | 0:0, 1:150, 2:200, 3:250 | 0:0, 3:30 | - |
| [Spring-Plating](../src/reg/Registry.as#L4345) | Obstacle mass multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:0.85, 2:0.7, 3:0.5, 33:0.3, 103:0.125 | - |
| [Improved Fuel](../src/reg/Registry.as#L4365) | Stage fuel multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.5, 103:2.5 | - |
| [Polishing](../src/reg/Registry.as#L4385) | Top speed multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.5, 103:2 | - |
| [Turbocompressor](../src/reg/Registry.as#L4405) | Stage power multiplier | 3 | 0:0, 1:100, 2:200, 3:300, 4:100 (1.3), 103:300 | 0:1, 1:1.05, 2:1.12, 3:1.2, 33:1.5, 103:2.5 | - |
| [VCR](../src/reg/Registry.as#L4426) | Cutscene replay | 1 | 0:0, 1:200 | 0:1 | - |
