dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local a = Pronouns["Parantajahiisi"]
local b = Pronouns["Snipuhiisi"]
local c = Pronouns["Stendari"]
SCENE = {

{id = "main", texts = {{text = [[There's a giant worm here. Strangely enough, it's not moving an inch at the moment.]]}}},
{id = "main", texts = {{text = [[You take a step closer, and it seems to notice you for the first time.
Its enormous yellow eye slowly pivots to gaze at you. Your hair begins to stand on end.]]}}},
{id = "main", texts = {{text = [[And yet... It stays obediently still.]]}}},
{id = "main", texts = {{text = [[It doesn't, as you'd typically expect, lunge towards you with the intent to swallow you whole.
It just stares for a long moment... as if expecting something from you.
]]}, {text = [[Back off
]], click = {{id = "away"}}}, {text = [[Mount]], click = {{id = "worm"}}}}},

{id = "away", texts = {{text = [[You quickly back off, intimidated by the worm's gaze.
It returns to staring at the wall blankly, completely unfazed by your actions.]]}}, sendto = {{file = "locations/lab.lua"}}},
{id = "worm", texts = {{text = [[You take a deep breath, take a step forward, brace yourself, and...]]}}},
{id = "worm", texts = {{text = [[...Before you know it, you've mounted the worm's back.
From here, the carpet of blue hair that coats its body actually feels quite soft.]]}}},
{id = "worm", texts = {{text = [[Then, a quiet rumbling... as the worm begin to gain speed.
Slowly at first, but then faster and faster, until the world begins to blur around you.]]}}},
{id = "worm", texts = {{text = [[Before long, you find yourself desperately clutching onto the worm's bow with both hands.
You stay like that for what seems like an eternity, holding on for dear life, and then...]]}}},
-- awesome gfx here
{id = "worm", texts = {{text = [[Sunlight covers your body and fills your eyes as the worm breaks through to the surface.]]}}},
{id = "worm", texts = {{text = [[By the time you realize you're in the air, you've already landed, with a loud thump that nearly knocks the wind out of you.]]}}},
{id = "worm", texts = {{text = [[You're still moving rather fast, skating along the grassy surface now, kicking up dirt and dust as you go.
Buildings come into view, and the worm finally begins to slow down upon seeing them.]]}}},
{id = "worm", texts = {{text = [[It takes a bit of effort to hold down your nausea for the rest of the trip... but you manage.
Eventually, the worm slows to a stop, causing a cloud of dust to billow out around you.
You dismount slowly, feeling somewhat dizzy.]]}}},
{id = "worm", texts = {{text = [[You're now standing in some sort of plaza.
It's surprisingly lively, with figures standing in the distance and chatting casually.]]}}},
{id = "worm", texts = {{text = [[And yet, before you've had the time to get your bearings further...
One of the figures begins to approach you. It looks like they're running.]]}}},
-- hiisi healer is the first to greet the player
{id = "worm", texts = {{text = [[Their boots are loud on the organized tile floor, and they nearly trip over their own feet as they sprint towards you with vigour.]]}}},
{id = "worm", texts = {{text = [[They skid to a stop in front of you and pull you into a hug before you can react, seeming overjoyed.]]}}},
{id = "worm", texts = {{text = [["]] .. Name_caps .. [[! You're here!"]], style = {"parantajahiisi"}},
{text = [[, they squeal, before releasing you and taking a step back.]]}}},
{id = "worm", texts = {{text = [[You realize then who it is - it's ]]}, {text = [[Parantajahiisi]], style = {"parantajahiisi"}}, {text = [[, the healer, looking better than ever;
]] .. a["Their"] .. [[ armor is freshly polished, shining a radiant pink.]]}}},
{id = "worm", texts = {{text = [["I've been waiting for you... Come on, come on, there's so much to see!"]], style = {"parantajahiisi"}}}},
{id = "worm", texts = {{text = a["They"] .. (Swap(a, "plural") and " grab your arm and begin " or " grabs your arm and begins ") .. [[to drag you along, to the very middle of the plaza.
An enormous blue crystal lies atop a pillar in front of you, providing a subtle glow to the surrounding area.]]}}},
{id = "worm", texts = {{text = [["So much happened so fast, it's all kind of a blur...
...B-but, in short... The Gods realized no one was fighting anymore, so we all moved up to the surface!]], style = {"parantajahiisi"}}}},
{id = "worm", texts = {{text = [[Those Holy Mountains that separated us all... They're all gone now.]], style = {"parantajahiisi"}}}},
{id = "worm", texts = {{text = [[Everyone left a lot behind... But, we've all been figuring things out up here.
And the sun, the sun...! Oh, it's so beautiful..."]], style = {"parantajahiisi"}}}},
{id = "worm", texts = {{text = a["They're"] .. [[ obviously elated, glancing eagerly between you and the sunrise in the distance, when ]] .. a["they"] .. [[ turn to notice two figures approaching.]]}}},
{id = "worm", texts = {{text = [[You instinctively scowl when you notice who they are: ]]}, {text = "Snipuhiisi", style={"snipuhiisi"}}, {text = " and "}, {text = "Stendari", style={"stendari"}},
{text = ". They both look somewhat amused to see such a cheerful reunion happening without them."}}},
{id = "worm", texts = {{text = [["Oi! What's all the commotion? Didja forget you weren't the only person in town, Pinky?"]], style={"snipuhiisi"}}}},
{id = "worm", texts = {{text = [["Heh.. Hey, maybe we should give them some time alone, y'know...
They're probably delirious from staying up all night in the plaza."]], style={"stendari"}}}},
{id = "worm", texts = {{text = [["H-hey! That's not true..." ]], style = {"parantajahiisi"}}, {text = a["they"] .. (Swap(a, "plural") and  " say, " or " says, ") .. "in a flustered tone that implies the opposite."}}},
{id = "worm", texts = {{text = [["Well, someone's gotta teach 'em about ]], style={"snipuhiisi"}}, {text = [[encounters]], style={"info"}},
{text = [[, and I doubt Pinky here is confident enough to get to it within the week..."]], style={"snipuhiisi"}}}},
{id = "worm", texts = {{text = [["Oh, don't be so hot-headed, Snipuhiisi..."]], style={"stendari"}}, {text = [[ Stendari says with an eye-roll.]]},
{text = [[
"Let's just let ]] .. Name_caps .. [[ decide."]], style={"stendari"}}}},
{id = "worm", texts = {{text = [[Parantajahiisi nods gently, more to ]] .. a["themself"] .. [[ than to anyone else.
Snipuhiisi scoffs, but relents with a shrug and a smirk. ]]}, {text = [["Fine, I guess..."]], style={"snipuhiisi"}}}},
{id = "worm", texts = {{text = b["They"] .. (Swap(c, "plural") and " turn " or " turns ") ..  [[to focus their attention on you now, looking slightly less combative now that ]] .. b["they've"] .. [[ stopped bickering with the healer.
Stendari smirks slightly as ]] .. c["they"] .. (Swap(c, "plural") and " stand beside " or " stands beside ") .. b["them"] .. [[, as enthusiastic to hear your response as Parantajahiisi is anxious.]]}}},
{id = "worm", texts = {{text = [[Choose who you'd like to have your first encounter with!
Don't worry, this won't lock you into any decisions later...
But it might give you a head start with the character you choose.
]], style = {"info"}}, {text = [[Parantajahiisi
]], click = {id = "healer", line = 1}}, {text = [[Snipuhiisi
]], click = {id = "sniper", line = 1}}, {text = [[Stendari
]], click = {id = "stendari", line = 1}}, {text = [[None of them]], click = {id = "none"}}}},
{id = "stendari", texts = {{text = [["Alright!"]]}, style={"stendari"}}},
{id = "stendari", startbattle = "stendari"},
{id = "none", texts = {{text = [[A pause. The three stare over at you for a long while, trying to judge whether or not you're joking.]]}}},
{id = "none", texts = {{text = [[Eventually, Snipuhiisi scoffs, and mutters under ]] .. b["their"] .. [[ breath: ]]}, {text = [["...What, you got an appointment or something?"]], style={"snipuhiisi"}}}},
{id = "none", texts = {{text = [[Parantajahiisi appears to be panicking. Stendari puts a comforting hand on ]] .. a["their"] .. [[ shoulder, and the three walk away without so much as a glance back at you.]]}}},

}