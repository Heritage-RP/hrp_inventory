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
		weight = 220,
		client = {
			status = { hunger = 200000 },
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
		weight = 350,
		client = {
			status = { thirst = 200000 },
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
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		},
		server = { export = 'hrp-radiation.consumable' },
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
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

	-- Hunting loot (hrp-hunting): crafting materials, not usable yet
	['cloth_scrap'] = {
		label = 'Cloth Scraps',
		weight = 50,
		description = 'Rags torn from ghouls. Can be turned into clothes.',
	},

	['raw_meat'] = {
		label = 'Raw Meat',
		weight = 250,
		description = 'Meat from a wild animal. Cook it before eating.',
	},

	['animal_hide'] = {
		label = 'Animal Hide',
		weight = 400,
		description = 'Hide from a wild animal.',
	},

	-- Radiation (hrp-radiation, PRODUCTION-SERVER#22 / #24)
	['canned_food'] = {
		label = 'Canned Food',
		weight = 400,
		description = 'Sealed before the war: safe from radiation.',
		client = {
			status = { hunger = 200000 },
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

	['recipe_antirad'] = {
		label = 'Recipe: Anti-Radiation Medication',
		weight = 10,
		stack = false,
		description = 'How to make the anti-radiation medication. Crafting comes with the workbench.',
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
	},
}
