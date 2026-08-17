return {
		start_battle = {
			{force = true, onlyif = Dates_so_far == 0, text = "O-oh, so you want to date me...?", text2 = "W-well, I... O-oh, gosh..."},
			{force = true, onlyif = Dates_so_far == 1, text = "W-well... Here we are again...", text2 = "This time, um... I'm prepared. I think."},
			{force = true, onlyif = Dates_so_far == 2, text = "W-wow... We're really doing this...", text2 = "L-let's go."},
			{force = true, onlyif = Dates_so_far >= 3, text = "E-ehehe... Hey, Knower...", text2 = "You sure have a lot of time on your hands..."},
		},
		victory = {
			{force = true, onlyif = Dates_so_far == 0, text = "O-oh...! You... you did it?", text2 = "Then, I-I guess we can... go on a date...!"},
			{force = true, onlyif = Dates_so_far == 1, text = "K-Knower...! A-again, you've...", text2 = "B-broken my shell... It seems..."},
			{force = true, onlyif = Dates_so_far == 2, text = "W-waaah! I-I didn't expect you to...", text2 = "F-fine, then! I-I won't worry anymore..."},
		},
		player_downed = {
			{force = true, onlyif = Dates_so_far ~= 2, text = "O-oh... You need a breather...?", text2 = "I-it's okay... Don't overdo it...!"},
			{force = true, onlyif = Dates_so_far ~= 2, text = "H-hey...! Don't look so sad!", text2 = "I-I get tired too... s-sometimes..."},
			{force = true, onlyif = Dates_so_far ~= 2, text = "K-Knower...! A-are you hurt...?", text2 = "O-oh... I left my healing gun in the office..."},

			{force = true, onlyif = Dates_so_far == 2, text = "H-hey...! Get up, Knower!", text2 = "Y-you haven't worked so hard... just to..."},
			{force = true, onlyif = Dates_so_far == 2, text = "W-what happened, Knower...? I...", text2 = "Come on...! I know you're stronger than that..."},
		},
		player_revived = {
			{force = true, onlyif = Dates_so_far ~= 2, text = ""},
			{force = true, onlyif = Dates_so_far ~= 2, text = ""},
			{force = true, onlyif = Dates_so_far ~= 2, text = ""},

			{force = true, onlyif = Dates_so_far == 2, text = "T-there you are, Knower...", text2 = "N-now... break that SHELL...!"},
			{force = true, onlyif = Dates_so_far == 2, text = "S-so strong...", text2 = "That's why I l-l... like you..."},
		},
		tempoup = { -- when tempo level increases, this uses the level it's increasing TO
			{chance = 75, onlyif = Tempo > 0, text = "M-maybe I am a bit nervous..."},
			{chance = 75, onlyif = Tempo > 1, text = "I-is this magic? Or... is this..."},
			{chance = 75, onlyif = Tempo > 2, text = "H-heh, Knower... are you a dancer...?"},
			{chance = 75, onlyif = Tempo > 3, text = "A-am I hearing my heartbeat, or yours...?"},
			{chance = 75, onlyif = Tempo > 4, text = "M-my heart... It's beating fast...!"},
		},
		glomp = {
			{chance = 25, text = "C'mere, c'mere..."},
			{chance = 25, text = "Oh, gosh... Can't hold back..."},
			{chance = 25, text = "Sweet...!!"},
		},
		fireball = {
			{chance = 25, text = "Is it getting hot in here, or...?"},
			{chance = 25, text = "H-hey... You're getting kinda close..."},
			{chance = 25, text = "Bring it in..."},
		},
		line = {
			{chance = 25, text = "S-self-care, um... is important..."},
			{chance = 25, text = "O-oh, gosh... I need a minute..."},
			{chance = 25, text = "Mm... Snack break."},
		},
		backstep = {
			{chance = 50, text = "Need some space..."},
			{chance = 50, text = "U-uwa...!!"},
		},
		plant_seeds = {
			{onlyif = Dates_so_far == 0, force = true, text = "All those pretty flowers in the Park...", text2 = "I... I guess they're only alive because of me..."},
			{onlyif = Dates_so_far == 1, force = true, text = "Spending time in the Park... in the sun...", text2 = "I-it's not nearly this nice when I'm alone..."},
			{onlyif = Dates_so_far >= 2, force = true, text = "I-isn't it just nice to see how things grow...?", text2 = "L-like plants... or like... feelings..."},
		},
	}