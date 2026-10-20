-- Fork patch (PRODUCTION-SERVER#390, refinement R2 of #249): the vanilla ox_inventory shops are removed
-- (General, Liquor, YouTool, Ammunation, PoliceArmoury, Medicine, BlackMarketArms, vending machines).
-- NPC counters are created in game by the staff with hrp-counters (/comptoirs): they sell and buy back items for
-- the server's currency or any item, with stock and daily caps, all decided by the server.
-- Keep this file returning a table: modules/shops/{client,server}.lua iterate over it.
return {}
