-- satiety = { hunger = n, thirst = n }: points (0-100) given back by hrp-life-and-death when the item is used. It reads
-- them server-side on ox_inventory:usedItem (client.status would only feed ox_core's statuses, which HRP does not use).
return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			image = 'burger_chicken.png',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					lib.print.debug('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					lib.print.debug('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					lib.print.debug('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					lib.print.debug('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					lib.print.debug('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		satiety = { hunger = 20 },
		weight = 220,
		client = {
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
		-- hrp-radiation: contaminated unless boiled
		server = { export = 'hrp-radiation.consumable' },
	},

	['sprunk'] = {
		label = 'Sprunk',
		satiety = { thirst = 20 },
		weight = 350,
		client = {
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['crafting_recipe_note'] = {
		label = 'Recipe Note',
		weight = 1,
		stack = false,
		consume = 0,
		client = {
			image = 'crafting_recipe_note.png'
		}
	},

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		satiety = { hunger = 2.5, thirst = 2.5 },
		weight = 500,
		client = {
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['water'] = {
		label = 'Water',
		satiety = { thirst = 20 },
		weight = 500,
		client = {
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	-- Hunting loot (hrp-hunting): crafting materials, used by the hrp-crafting recipes
	['cloth_scrap'] = {
		label = 'Cloth Scraps',
		weight = 50,
		description = 'Rags torn from ghouls. Can be turned into clothes.',
	},

	['raw_meat'] = {
		label = 'Raw Meat',
		satiety = { hunger = 8 },
		weight = 250,
		description = 'Meat from a wild animal. Cook it at a campfire: eaten raw, it is contaminated.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['animal_hide'] = {
		label = 'Animal Hide',
		weight = 400,
		description = 'Hide from a wild animal.',
	},

	-- Fishing (hrp-fishing, PRODUCTION-SERVER#145): raw fish are food, contaminated unless boiled (hrp-radiation);
	-- irradiated catches carry metadata.contamination on top
	['fishing_rod'] = {
		label = 'Fishing Rod',
		weight = 1500,
		stack = false,
		consume = 0,
		close = true,
		description = 'Use it facing a lake, a river or the sea.',
		client = { export = 'hrp-fishing.useRod' },
	},

	['fishing_bait'] = {
		label = 'Fishing Bait',
		weight = 20,
		description = 'Worms and scraps. One per fish hooked.',
	},

	['fish_carp'] = {
		label = 'Carp',
		satiety = { hunger = 12 },
		weight = 800,
		description = 'A freshwater carp. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_perch'] = {
		label = 'Perch',
		satiety = { hunger = 8 },
		weight = 400,
		description = 'A small freshwater perch. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_trout'] = {
		label = 'Trout',
		satiety = { hunger = 10 },
		weight = 600,
		description = 'A river trout. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_catfish'] = {
		label = 'Catfish',
		satiety = { hunger = 18 },
		weight = 1500,
		description = 'A big catfish from the muddy bottom. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_sardine'] = {
		label = 'Sardine',
		satiety = { hunger = 5 },
		weight = 150,
		description = 'A small sea fish. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_mackerel'] = {
		label = 'Mackerel',
		satiety = { hunger = 9 },
		weight = 500,
		description = 'A sea mackerel. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_snapper'] = {
		label = 'Red Snapper',
		satiety = { hunger = 13 },
		weight = 900,
		description = 'A red snapper from the sea floor. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_tuna'] = {
		label = 'Tuna',
		satiety = { hunger = 25 },
		weight = 3000,
		description = 'A large tuna. A feast. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['fish_mutant'] = {
		label = 'Mutant Fish',
		satiety = { hunger = 15 },
		weight = 1200,
		description = 'Two heads, too many eyes. Caught in contaminated water. Boil it before eating.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	-- Survival (hrp-survival, PRODUCTION-SERVER#149 / #144 / #148): campfire, canteen, harvesting tools and materials
	['wood'] = {
		label = 'Wood',
		weight = 500,
		close = true,
		description = 'Firewood and building material. Use it to light a campfire (3 logs).',
		client = { export = 'hrp-survival.useWood' },
	},

	['cooked_meat'] = {
		label = 'Cooked Meat',
		satiety = { hunger = 25 },
		weight = 200,
		description = 'Grilled over a campfire: safe to eat.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
	},

	['cooked_fish'] = {
		label = 'Cooked Fish',
		satiety = { hunger = 20 },
		weight = 300,
		description = 'Grilled over a campfire: safe to eat.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
	},

	['canteen'] = {
		label = 'Canteen',
		weight = 300,
		stack = false,
		close = true,
		consume = 0,
		description = 'Fill it at a river, a lake or a tap.',
		client = { image = 'water.png', export = 'hrp-survival.useCanteen' }, -- provisional image (PRODUCTION-SERVER#328)
	},

	['water_tablet'] = {
		label = 'Water Treatment Tablet',
		weight = 5,
		close = true,
		description = 'Makes the water of a canteen safe to drink.',
		client = { export = 'hrp-survival.useTablet' },
	},

	['hatchet'] = {
		label = 'Hatchet',
		weight = 1200,
		stack = false,
		close = true,
		consume = 0,
		description = 'Chops wood from trees. Wears out.',
		client = { image = 'WEAPON_HATCHET.png', export = 'hrp-survival.useTool' },
	},

	['pickaxe'] = {
		label = 'Pickaxe',
		weight = 2500,
		stack = false,
		close = true,
		consume = 0,
		description = 'Use it in a quarry to mine iron ore. Wears out.',
		client = { export = 'hrp-survival.useTool' },
	},

	['toolkit'] = {
		label = 'Toolkit',
		weight = 1500,
		stack = false,
		close = true,
		consume = 0,
		description = 'Strips wrecks and pre-war appliances for metal and parts. Wears out.',
		client = { image = 'advancedkit.png', export = 'hrp-survival.useTool' }, -- provisional image (PRODUCTION-SERVER#328)
	},

	['iron_ore'] = {
		label = 'Iron Ore',
		weight = 600,
		description = 'Raw ore from a quarry.',
	},

	['electronic_parts'] = {
		label = 'Electronic Parts',
		weight = 100,
		description = 'Circuits and components taken from pre-war devices.',
	},

	-- Foraging and farming (hrp-survival, PRODUCTION-SERVER#146 / #147). Raw food goes through hrp-survival's export,
	-- which hands it on to hrp-radiation (contaminated unless boiled; metadata.contamination when irradiated) and rolls
	-- food poisoning (metadata.toxicity)
	['wild_berries'] = {
		label = 'Wild Berries',
		satiety = { hunger = 5 },
		weight = 50,
		description = 'Picked from a bush. Not all of them agree with everyone.',
		client = {
			anim = 'eating',
			usetime = 2000,
		},
		server = { export = 'hrp-survival.food' },
	},

	['wild_mushrooms'] = {
		label = 'Wild Mushrooms',
		satiety = { hunger = 7 },
		weight = 80,
		description = 'Found at the foot of a tree. Some are poisonous, and nothing tells which.',
		client = {
			anim = 'eating',
			usetime = 2500,
		},
		server = { export = 'hrp-survival.food' },
	},

	['wild_herbs'] = {
		label = 'Wild Herbs',
		weight = 20,
		description = 'Medicinal herbs. Used in remedies.',
	},

	['seed_potato'] = {
		label = 'Seed Potatoes',
		weight = 100,
		consume = 0,
		close = true,
		description = 'From the bunkers. Plant them in a plot, then water them.',
		client = { export = 'hrp-survival.useSeed' },
	},

	['seed_tomato'] = {
		label = 'Tomato Seeds',
		weight = 10,
		consume = 0,
		close = true,
		description = 'From the bunkers. Plant them in a plot, then water them.',
		client = { export = 'hrp-survival.useSeed' },
	},

	['seed_pumpkin'] = {
		label = 'Pumpkin Seeds',
		weight = 10,
		consume = 0,
		close = true,
		description = 'From the bunkers. Plant them in a plot, then water them.',
		client = { export = 'hrp-survival.useSeed' },
	},

	['potato'] = {
		label = 'Potato',
		satiety = { hunger = 6 },
		weight = 200,
		description = 'Fresh from the field. Bake it at a campfire, or boil it.',
		client = {
			anim = 'eating',
			usetime = 2500,
		},
		server = { export = 'hrp-survival.food' },
	},

	['tomato'] = {
		label = 'Tomato',
		satiety = { hunger = 5 },
		weight = 150,
		description = 'Fresh from the field. Boil it before eating it.',
		client = {
			anim = 'eating',
			usetime = 2000,
		},
		server = { export = 'hrp-survival.food' },
	},

	['pumpkin'] = {
		label = 'Pumpkin',
		satiety = { hunger = 15 },
		weight = 2500,
		description = 'A whole pumpkin. Roast it at a campfire.',
		client = {
			anim = 'eating',
			usetime = 4000,
		},
		server = { export = 'hrp-survival.food' },
	},

	['baked_potato'] = {
		label = 'Baked Potato',
		satiety = { hunger = 18 },
		weight = 180,
		description = 'Baked over a campfire: safe to eat.',
		client = {
			anim = 'eating',
			usetime = 3000,
		},
	},

	['roasted_pumpkin'] = {
		label = 'Roasted Pumpkin',
		satiety = { hunger = 40 },
		weight = 1200,
		description = 'Roasted over a campfire: safe to eat, and plenty of it.',
		client = {
			anim = 'eating',
			usetime = 4000,
		},
	},

	-- Radiation (hrp-radiation, PRODUCTION-SERVER#22 / #24)
	['canned_food'] = {
		label = 'Canned Food',
		satiety = { hunger = 20 },
		weight = 400,
		description = 'Sealed before the war: safe from radiation.',
		client = {
			anim = 'eating',
			usetime = 2500,
		},
	},

	['antirad'] = {
		label = 'Anti-Radiation Medication',
		weight = 50,
		description = 'Removes all the radiation within ten seconds.',
		client = {
			image = 'medikit.png',
			anim = { dict = 'mp_suicide', clip = 'pill', flag = 49 },
			usetime = 2500,
			cancel = true,
		},
		server = { export = 'hrp-radiation.useAntirad' },
	},

	['gas_mask'] = {
		label = 'Gas Mask',
		weight = 800,
		stack = false,
		close = true,
		consume = 0,
		description = 'Use to put on / take off. Filters part of the radiation and slowly wears out.',
		client = { image = 'mask.png' },
		server = { export = 'hrp-radiation.useGear' },
	},

	['hazmat_suit'] = {
		label = 'Hazmat Suit',
		weight = 3000,
		stack = false,
		close = true,
		consume = 0,
		description = 'Use to put on / take off. Blocks most of the radiation and slowly wears out.',
		server = { export = 'hrp-radiation.useGear' },
	},

	-- Clothing items for inventory slots
	['mask'] = {
		label = 'Mask',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['hat'] = {
		label = 'Hat',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['earrings'] = {
		label = 'Earrings',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['glasses'] = {
		label = 'Glasses',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['chain'] = {
		label = 'Chain',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['undershirt'] = {
		label = 'Undershirt',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['jacket'] = {
		label = 'Jacket',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['bodyarmor'] = {
		label = 'Body Armor',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['bracelet'] = {
		label = 'Bracelet',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['watch'] = {
		label = 'Watch',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['bag'] = {
		label = 'Bag',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['pants'] = {
		label = 'Pants',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['shoes'] = {
		label = 'Shoes',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['gloves'] = {
		label = 'Gloves',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		}
	},

	['skateboard'] = {
		label = 'Skateboard',
		weight = 2000,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-skating.useSkateboardItem'
		}
	},

	['firstaid'] = {
		label = 'First Aid Kit',
		weight = 500,
		stack = true,
		close = true,
		description = 'A first aid kit used to revive downed players',
		client = { image = 'medikit.png' }, -- provisional image (PRODUCTION-SERVER#328)
	},

	-- Lore documents (hrp-lore, PRODUCTION-SERVER#203): a blank item opens the editor and is consumed once written;
	-- lore_document carries metadata.docId, label (title), description and weight set by hrp-lore.
	-- allowArmed: reading and writing open a UI without animation, so a weapon in hand must not block them
	-- (PRODUCTION-SERVER#208). Images: provisional notebook (PRODUCTION-SERVER#328).
	['blank_sheet'] = {
		label = 'Blank Sheet',
		weight = 10,
		consume = 0,
		description = 'A blank sheet of paper. Use it to write.',
		allowArmed = true,
		client = { image = 'crafting_recipe_note.png' },
		server = { export = 'hrp-lore.useBlank' },
	},

	['blank_book'] = {
		label = 'Blank Book',
		weight = 300,
		consume = 0,
		description = 'A notebook with empty pages. Use it to write.',
		allowArmed = true,
		client = { image = 'crafting_recipe_note.png' },
		server = { export = 'hrp-lore.useBlank' },
	},

	['lore_document'] = {
		label = 'Document',
		weight = 10,
		consume = 0,
		description = 'Use it to read.',
		allowArmed = true,
		client = { image = 'crafting_recipe_note.png' },
		server = { export = 'hrp-lore.useDocument' },
	},

	-- Mounts (hrp-animal-riding, PRODUCTION-SERVER#153): use it while looking at a deer or a boar to tame it.
	-- hrp-animal-riding takes one bait server-side when the taming starts (consume = 0 here).
	['animal_bait'] = {
		label = 'Animal Bait',
		weight = 100,
		consume = 0,
		close = true,
		description = 'Berries and salt mixed with meat. Hold it out to a wild deer or boar to tame it as a mount.',
		client = { export = 'hrp-animal-riding.useBait' },
	},
}
