# Progression and modes

## Unlocks, BP and cards

Story is available on a fresh profile. Leaving a completion screen opens the first locked mode in this order: Payload, Classic, Sandbox. The usual route is to clear Story, then Payload, then Classic. Holding the main-menu title for 120 units of game delta also unlocks all three. [Mode menu](../src/gui/NewGameMenu.as#L53-L99) · [Completion unlock](../src/gui/menus/EndGameScreen.as#L412-L433) · [Title shortcut](../src/gui/MainMenuTitle.as#L23-L64)

Bonus Points (BP) are shared across the profile. Medals, cards and the Fidelity Card upgrade award BP. The Fidelity Card starts at 0 BP per day. Its first three levels pay 1, 2 and 3 BP when daily results are collected. The Bonus Shop charges BP when a level is first unlocked. [BP balance](../src/system/ProfileState.as#L279-L287) · [Daily awards](../src/game/result/Result.as#L190-L202) · [Fidelity Card](../src/reg/Registry.as#L4084-L4101) · [Bonus Shop](../src/shop/bonusshop/BonusShopEngine.as#L194-L221)

Medal checks compare progress against thresholds in the registry. Each new tier pays its own listed reward. Some medals also give stat bonuses or item unlocks. [Medal checks](../src/MedalCheck.as#L304-L366) · [Medal rewards](../src/Main.as#L908-L912) · [Payload Master tiers](../src/reg/Registry.as#L4783-L4800)

The Challenge medals allow up to 10 days for Story, 28 for 4,000,000 Story, 15 for Payload and 10 for Classic. The two Speedrunner medals use 6 days for Story and 13 for 4,000,000 Story. Payload checks the slot's day minus one, since its results already advanced the counter. [Challenge goals](../src/reg/Registry.as#L4924-L4954) · [Speedrunner goals](../src/reg/Registry.as#L5006-L5018) · [Day checks](../src/MedalCheck.as#L692-L753)

The completion screen offers four packs with different item weights. The draw favors item cards while many regular items remain locked and shifts toward BP as they are collected. Owned regular items are removed from the draw. Regular item cards unlock their items directly. The six Omega items in the card pool each need three matching cards. [Pack composition](../src/cards/CardOdds.as#L85-L113) · [Pack weights](../src/cards/CardOdds.as#L131-L165) · [Omega cards](../src/gui/menus/EndGameScreen.as#L371-L405) · [Regular unlocks](../src/gui/menus/EndGameScreen.as#L408-L409)

## Story

The default goal is 200,000 world pixels of altitude. Reaching it starts the Space Stage. The ending triggers after 200 updates with Space Stage player Y at or below `−2`. The count carries over between visits above the threshold within the same attempt. The goal menu opens after earning the Story medal or unlocking Sandbox.

| Altitude goal | Completion cards |
| ---: | ---: |
| 200,000 | 5 |
| 500,000 | 6 |
| 1,000,000 | 7 |
| 4,000,000 | 10 |

[Altitude goals](../src/system/Global.as#L67-L70) · [Goal menu](../src/gui/NewGameMenu.as#L205-L212) · [Space entry](../src/game/SpaceIndicator.as#L36-L60) · [Space Stage victory](../src/game/spacestage/SpaceStage.as#L115-L173) · [Card counts](../src/gui/menus/EndGameScreen.as#L260-L287)

## Classic

Reach an absolute horizontal position of 500,000 world pixels. Either direction counts. Classic removes wind, obstacles and the Space Stage. A launcher with two boost slots is placed on a 45° slope. Completion gives five cards. [Distance goal](../src/system/Global.as#L66) · [Classic setup and finish](../src/game/GameEngineClassic.as#L53-L94) · [Card count](../src/gui/menus/EndGameScreen.as#L275-L280)

## Payload

Carry a tethered load. The listed weight is the starting mass before scaling it against player mass. Payload sets the base launch, boost and stage power multipliers to 1.5, 1.2 and 1.3. [Power multipliers](../src/game/StatHooks.as#L126-L130) Milestones use the penguin's altitude above ground. Each load has five milestones at 10,000, 25,000, 50,000, 100,000 and 200,000 world pixels.

| Listed weight | Base BP at the five milestones | Payload Master medal at | Daily cash bonus |
| ---: | --- | ---: | ---: |
| 1 | 1, 2, 3, 4, 5 | 25,000 | 0% |
| 15 | 2, 4, 6, 8, 10 | 50,000 | 15% |
| 75 | 3, 6, 9, 12, 15 | 100,000 | 50% |
| 150 | 5, 10, 15, 25, 50 | 200,000 | 100% |

The live check requires altitude strictly above the next milestone. Earning a new Payload Master tier replaces that milestone's BP with the medal reward of 10, 20, 50 or 100 BP. The cash bonus applies to altitude, air time and speed cash. The completion check runs on return from results and requires a recorded altitude of at least 200,000 for all four loads in the same slot. It awards six cards.

[Loads and milestones](../src/reg/Registry.as#L5185-L5245) · [Mass scaling](../src/game/GameEnginePayload.as#L60-L83) · [Altitude signal](../src/game/gameobjects/environment/Ground.as#L31-L59) · [Milestone check](../src/game/GameEnginePayload.as#L166-L238) · [Medal rewards](../src/reg/Registry.as#L4783-L4800) · [Cash bonus](../src/game/result/Result.as#L120-L144) · [Completion](../src/Main.as#L830-L846) · [Card count](../src/gui/menus/EndGameScreen.as#L275-L277)

## Sandbox

Sandbox exposes settings for physics, time scale, money, obstacles, payload and the space goal. A positive payload weight enables the tethered load. A positive space goal enables the Space Stage. Payload milestones are disabled. The only available medal is the Sandbox medal. Sandbox results count Sandbox days and skip the normal profile flight records. [Settings](../src/game/sandboxmode/SandBoxScreen.as#L127-L149) · [Engine rules](../src/game/GameEngineSandbox.as#L39-L100) · [Medals](../src/MedalCheck.as#L25-L38) · [Result records](../src/game/result/Result.as#L154-L156) · [Day counters](../src/game/result/Result.as#L190-L202)
