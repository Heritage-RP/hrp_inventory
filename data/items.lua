-- Base items of the inventory. A resource that brings its own items declares them in a file of its own
-- (fxmanifest `hrp_inventory_items 'items.json'`, modules/items/declared.lua — PRODUCTION-SERVER#464).
-- satiety = { hunger = n, thirst = n }: points (0-100) given back by hrp-life-and-death when the item is used. It reads
-- them server-side on ox_inventory:usedItem (client.status would only feed ox_core's statuses, which HRP does not use).
return {
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

	-- Crafting material: dropped by creatures, given back by hrp-item-clothes when a garment is cut (R11, #43)
	['cloth_scrap'] = {
		label = 'Cloth Scraps',
		weight = 50,
		description = 'Rags of fabric. Can be turned into clothes.',
	},

	-- Clothing items for inventory slots
	['mask'] = {
		label = 'Mask',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['hat'] = {
		label = 'Hat',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['earrings'] = {
		label = 'Earrings',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['glasses'] = {
		label = 'Glasses',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['chain'] = {
		label = 'Chain',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['undershirt'] = {
		label = 'Undershirt',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['jacket'] = {
		label = 'Jacket',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['bodyarmor'] = {
		label = 'Body Armor',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['bracelet'] = {
		label = 'Bracelet',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['watch'] = {
		label = 'Watch',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['bag'] = {
		label = 'Bag',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['pants'] = {
		label = 'Pants',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['shoes'] = {
		label = 'Shoes',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
		}
	},

	['gloves'] = {
		label = 'Gloves',
		weight = 100,
		stack = false,
		consume = 0,
		server = {
			export = 'hrp-item-clothes.useClothingItem'
		},
		-- R11 (#43): cut a clothing item into cloth scraps (hrp-item-clothes decides, server side)
		buttons = {
			{ label = 'Découper', action = function(slot) exports['hrp-item-clothes']:cutClothing(slot) end }
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
}
