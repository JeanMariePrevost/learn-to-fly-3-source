# Flight and payouts

## Tick and coordinates

- The stage targets 65 FPS. Simulation `delta` uses a 60 FPS base. The Off setting caps it at 1 and Low caps it at 2. Nape takes 12 steps of `delta / (12 * 60)` seconds per tick. [Frame rate](../src/system/Global.as#L30) · [Delta](../src/Main.as#L764-L779) · [Physics step](../src/game/PhysicsEngine.as#L73-L78)
- Position is measured in world pixels. Screen Y grows downward. Speed is the distance between consecutive player sprite positions in world coordinates divided by `delta`. [Position and speed](../src/game/gameobjects/player/Player.as#L141), [speed calculation](../src/game/gameobjects/player/Player.as#L280)
- Gravity is `250 * gravityMult` in positive Y. Body mass is `max(1, (body weight + gear weight) * weightMult)` before the hidden multiplier. The physics mass applies that multiplier and clamps to 1 again. [Gravity](../src/game/PhysicsEngine.as#L61), [mass](../src/game/gameobjects/player/Player.as#L194)

## Launch, stages and boosts

`lerp(a, b, t, p)` below means `a + (b - a) * clamp(t, 0, 1)^p`. [Interpolation](../framework/lbg/utils/NumberUtils.as#L48)

| Calculation | Rule | Source |
| --- | --- | --- |
| Thrust impulse magnitude | `4.15 * mass * thrustPower` | [Player](../src/game/gameobjects/player/Player.as#L254), [impulse](../src/game/gameobjects/GameObject.as#L205) |
| Standard stage or boost thrust power | `item power * delta * weight ratio * stage or boost power multiplier` | [Stage](../src/game/gameobjects/player/stage/AbstractStage.as#L57), [boost](../src/game/gameobjects/player/boost/SimpleBoost.as#L101) |
| Standard fuel | Starts at `item fuel * stage or boost fuel multiplier`. Burns `delta` per active tick. | [Stage](../src/game/gameobjects/player/stage/AbstractStage.as#L41), [stage fuel](../src/game/gameobjects/player/stage/AbstractStage.as#L72), [boost fuel](../src/game/gameobjects/player/boost/SimpleBoost.as#L47) |
| Effective top speed | `round((body top speed + flat bonus) * speed multiplier)` | [Player](../src/game/gameobjects/player/Player.as#L271) |

The weight curve supplies `P` (power ratio at zero mass), `C` (cutoff mass), and `H` (half-power step). All three can change with item level. [Weight curve](../src/reg/StatPowerAtWeight.as#L37)

| Mass `m` | Weight ratio |
| --- | --- |
| `m <= 0` | `P` |
| `0 < m < C` | `lerp(P, 1, m / C, 1.4)` |
| `m = C` | `1` |
| `C < m < C + H` | `lerp(1, 0.5, (m - C) / H, 1.6)` |
| `m >= C + H` | `0.5^((m - C) / H)` |

Launchers choose their own impulse, angle, and timing. The shared launcher call can clear momentum and apply temporary drag and obstacle-mass reductions. Individual stages and boosts can also override the standard thrust and fuel behavior. [Launcher impulse](../src/game/gameobjects/player/launcher/AbstractLauncher.as#L125), [equipment](items.md)

## Drag and flight end

- For `SimpleBody`, below top speed, drag starts at `lerp(0.0045, 0.009, speed / topSpeed, 1.5)`. Above top speed, it is `0.009 + 0.035 * redzone`, where `redzone = (speed - topSpeed) / topSpeed`. Only 10% of the part of `redzone` above 1 is counted. [Constants](../src/game/gameobjects/player/body/SimpleBody.as#L28), [drag](../src/game/gameobjects/player/body/SimpleBody.as#L130)
- Air density scales drag. It interpolates through `1`, `0.9`, `0.8`, and `0.5` at 0%, 75%, 95%, and 100% of the space altitude. Drag is smoothed, adjusted for delta, and reduced when moving downward. The final velocity multiplier is `1 - (1 - drag) * dragMult`. [Density](../src/game/gameobjects/player/body/SimpleBody.as#L192), [drag application](../src/game/gameobjects/player/Player.as#L241)
- The in-flight timer adds `delta * (1000 / 65)` ms after launch while the day-end signal is false. Results use this air time. The separate elapsed-day clock reads `getTimer()` and subtracts pauses. [Air time](../src/game/FlightTimer.as#L76), [elapsed day](../src/game/StatsOfTheDay.as#L71)
- Auto end builds the end-day counter when the stages are spent or stopped, no boost is in use, and the player moves at speed 1.5 or less or fails the direction check. Moving the right way means at least 1 px up per tick, or 2 px right in Classic. Ground contact also advances the counter. Results start when the counter reaches 150. [End-day counter](../src/game/gameobjects/player/Player.as#L330), [results trigger](../src/game/GameEngine.as#L321)

## Flight powers

The exported startup leaves these effects off. If multiple flags are passed, the engine uses the first one in the order below. [Startup](../src/ScreenManager.as#L108-L116) · [Effects](../src/game/GameEngine.as#L247-L260)

| Power | Effect |
| --- | --- |
| Earninator | Adds 1 to the earnings multiplier. |
| Floatifier | Multiplies gravity by 0.3 and drag by 0.7. Adds 0.08 to the stage and boost power multipliers and 0.2 to the launch power multiplier. |
| Speedifier | Adds 0.4 to the stage and boost power multipliers and 0.1 to the launch power multiplier. Multiplies drag by 0.4. |

## Cash

Let `A`, `T`, and `S` be the raw altitude, air time, and speed rewards. Classic uses the greater of the farthest left and farthest right distances from the origin in place of altitude. Speed uses the filtered record, which can lag a brief spike. [Result inputs](../src/game/result/Result.as#L61), [speed record](../src/game/StatsOfTheDay.as#L126)

| Reward | Formula | Source |
| --- | --- | --- |
| Altitude or distance `A` | For `x = distanceOrAltitude + 60` px, `0.009 * x + (0.001 * x)^1.6` | [Altitude and distance](../src/system/Global.as#L109) |
| Air time `T` | `t = max(airTimeMs - 4250, 0)`. Base is `500 * (t / 40000)^1.3` through `t = 40000`, then `500 + (t - 40000) / 30`. Blend base with `A` using altitude share `lerp(0, 0.35, t / 240000, 0.6)`. Soft cap starts at 3500 with 100-dollar brackets. | [Air time cash](../src/system/Global.as#L128) |
| Speed `S` | `v = 0.7 * max(recordedSpeed - 4.5, 0)`. Raw reward is `0.7 * (v + (0.17 * v)^2.7) + A * lerp(0, 0.2, v / 50, 0.6) + T * lerp(0, 0.1, v / 50, 0.6)`. The soft cap uses 100 brackets from 1000 to 50000. | [Speed cash](../src/system/Global.as#L151) |
| Bonus earnings | `flatMoney + round(baseCash * moneyMult - baseCash)`, where `baseCash = A + T + S` | [Bonus earnings](../src/game/result/Result.as#L93-L105) |
| Daily interest | `round(max(0, min(interestCap, cashOnHand * rate)))` when the Bonus Shop upgrade is active. | [Interest](../src/game/result/Result.as#L105) |
| Payload bonus | `(A + T + S) * payloadRatio`. Ratios for payloads 1 to 4 are 0%, 15%, 50%, and 100%. | [Payload bonus](../src/game/result/Result.as#L120) |

Air time brackets start at a 0.99 multiplier, fall by 0.01 per bracket, and stop falling at 0.05. Speed brackets interpolate from 1 to 0.01 with exponent 0.05. Result rows convert to signed 32-bit integers before summing. [Soft caps](../framework/lbg/utils/NumberUtils.as#L194), [Result rows](../src/game/result/ResultScreen.as#L104-L117)
