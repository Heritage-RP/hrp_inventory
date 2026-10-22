# Patches

Upstream: https://github.com/CommunityOx/ox_inventory (main)

Fork of CommunityOx/ox_inventory for the core of Heritage-RP/PRODUCTION-SERVER. Every patch is generic: a server sets its own
values through convars or other resources (Heritage-RP/PRODUCTION-SERVER docs/dev/forks.md).

| Patch | Kind | Upstream | Files |
|---|---|---|---|
| Logs through HrpLog (`@hrp-metrics/lib/log.lua`), `lib.print` instead of `print` | generic | no | `fxmanifest.lua`, `init.lua`, `modules/inventory/server.lua`, `modules/items/client.lua`, `modules/shops/server.lua` |
| Declared items: a resource names its items file in its fxmanifest (`hrp_inventory_items 'items.json'`), loaded on both sides (PRODUCTION-SERVER#464) | generic | candidate | `modules/items/declared.lua`, `modules/items/shared.lua`, `fxmanifest.lua`, `tests/lua/declared_items_spec.lua` |
| Searchable bins: street, recycling and skip models too, map props keyed by rounded coordinates with a distance check and a creation cooldown (PRODUCTION-SERVER#400; its HrpLog calls would become `lib.print` upstream) | generic | candidate | `modules/dumpsters/shared.lua`, `modules/inventory/client.lua`, `client.lua`, `server.lua`, `locales/en.json`, `locales/fr.json`, `tests/lua/dumpsters_spec.lua` |
| Phantom weapon: a leftover `currentWeapon` no longer refuses items with "You cannot perform this action" (PRODUCTION-SERVER#208) | generic | candidate | `modules/weapon/shared.lua`, `client.lua`, `tests/lua/weapon_state_spec.lua` |
| Base items: `satiety` points read by hrp-life-and-death instead of ox_core statuses, items of core resources (hrp-crafting recipe note, hrp-lore sheets and documents with `allowArmed`, cloth scraps, first aid kit), dead items removed (`testburger`, npwd phone hooks) | generic | no | `data/items.lua`, `modules/items/containers.lua`, `web/images/crafting_recipe_note.png` |
| Clothing for hrp-item-clothes: 14 clothing items with a "Cut up" button (`cut_up` locale), slots 31–44 drawn around a silhouette with their icons and labels, model / texture in the tooltip | generic | no | `data/items.lua`, `locales/en.json`, `locales/fr.json`, `fxmanifest.lua`, `web/images/*.png`, `web/images/c-icons/*.png`, `web/src/components/inventory/InventoryGrid.tsx`, `web/src/components/inventory/InventorySlot.tsx`, `web/src/components/inventory/SlotTooltip.tsx`, `tests/lua/clothing_cut_spec.lua` |
| Inventory layout: header with icons, translated title and weight bar, amount field and Use / Give under the grids (Escape closes), UI texts through `ui_*` locales | generic | no | `web/package.json`, `web/pnpm-lock.yaml`, `web/src/App.tsx`, `web/src/components/inventory/index.tsx`, `web/src/components/inventory/InventoryControl.tsx`, `web/src/components/inventory/InventoryGrid.tsx`, `web/src/components/utils/WeightBar.tsx`, `locales/en.json`, `locales/fr.json` |
| UI themes: `neutral` (the upstream look, default) or any theme a resource declares (`hrp_ui_theme '<path>/<name>.css'` in its fxmanifest: the themed look, coloured by the `--hrp-*` tokens of that stylesheet, which may also set the `--inv-*` skin variables), picked by the replicated convar `hrp_ui_theme` (PRODUCTION-SERVER#476, #520) | generic | no | `modules/theme/shared.lua`, `client.lua`, `web/src/theme.ts`, `web/src/main.tsx`, `web/src/App.tsx`, `web/src/index.scss`, `web/src/components/utils/WeightBar.tsx`, `web/src/components/inventory/InventorySlot.tsx`, `tests/lua/theme_spec.lua` |
| Item images: every base item, ammo, component and tool-like weapon shows a pixel art icon of [SwisserDev/fivem-icons-pixel](https://github.com/SwisserDev/fivem-icons-pixel) (CC0), listed in `web/images/readme.md`; the items that borrowed another item's image get their own, `at_muzzle_precision'.png` renamed (PRODUCTION-SERVER#242) | generic | no | `web/images/*.png`, `web/images/readme.md`, `data/items.lua`, `tests/lua/item_images_spec.lua` |
| No vanilla shops: `data/shops.lua` returns an empty table, hrp-counters sells (PRODUCTION-SERVER#390) | generic | no | `data/shops.lua`, `tests/lua/shops_spec.lua` |
| No crafting bench: `data/crafting.lua` returns an empty table, hrp-crafting crafts | generic | no | `data/crafting.lua` |
| Tests (Lua 5.4 in docker, `just test`) | generic | no | `tests/run.sh`, `tests/lua/*_spec.lua` |
| Documentation of the fork | generic | no | `README.md`, `PATCHES.md` |

