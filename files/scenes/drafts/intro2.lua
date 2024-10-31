dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local a = Pronouns["Parantajahiisi"]
local b = Pronouns["Kranuhiisi"]
local c = Pronouns["Stendari"]
SCENE = {

{track = 1, texts = {{text = [[There's a giant worm here. Strangely enough, it's not moving an inch at the moment.]]}}},
{track = 1, texts = {{text = [[It looks no different from the other worms you've seen before...
aside from the large yellow bow that's been decoratively tied to the back of its head.]]}}},
{track = 1, texts = {{text = [[You take a step closer, and it seems to notice you for the first time.
Its enormous yellow eye slowly pivots to gaze at you. Your hair begins to stand on end.]]}}},
{track = 1, texts = {{text = [[And yet... It stays obediently still.]]}}},
{track = 1, texts = {{text = [[It doesn't, as you'd typically expect, lunge towards you with the intent to swallow you whole.
It just stares for a long moment... as if expecting something from you.]]}},
choices = {
    {name = "Back off", location = "left", gototrack = 2},
    {name = "Mount", location = "right", gototrack = 3},
}},
{track = 2, texts = {{text = [[You quickly back off, intimidated by the worm's gaze.
It returns to staring at the wall blankly, completely unfazed by your actions.]]}}},
{track = 3, texts = {{text = [[You take a deep breath, take a step forward, brace yourself, and...]]}}},
{track = 3, texts = {{text = [[...Before you know it, you've mounted the worm's back.
From here, the carpet of blue hair that coats its body actually feels quite soft.]]}}},
{track = 3, texts = {{text = [[Then, a quiet rumbling... as the worm begins gaining speed.
Slowly at first, but then faster and faster, until the world begins to blur around you.]]}}},
{track = 3, texts = {{text = [[Before long, you find yourself desperately clutching onto the worm's bow with both hands.
You stay like that for what seems like an eternity, holding on for dear life, and then...]]}}},
-- awesome gfx here
{track = 3, texts = {{text = [[Sunlight covers your body and fills your eyes as the worm breaks through to the surface.]]}}},
{track = 3, texts = {{text = [[By the time you realize you're in the air, you've already landed, with a loud thump that nearly knocks the wind out of you.]]}}},
{track = 3, texts = {{text = [[You're still moving rather fast, skating along the grassy surface now, kicking up dirt and dust as you go.
Buildings come into view, and the worm finally begins to slow down upon seeing them.]]}}},
{track = 3, texts = {{text = [[It takes a bit of effort to hold down your nausea for the rest of the trip... but you manage.
Eventually, the worm slows to a stop, causing a cloud of dust to billow out around you.
You dismount slowly, feeling somewhat dizzy.]]}}},
{track = 3, texts = {{text = [[You're now standing in some sort of plaza.
It's surprisingly lively, with figures standing in the distance and chatting casually.]]}}},
{track = 3, texts = {{text = [[And yet, before you've had the time to get your bearings further...
One of the figures begins to approach you. It looks like they're running.]]}}},
-- hiisi healer is the first to greet the player
{track = 3, texts = {{text = [[Their boots are loud on the organized tile floor, and they nearly trip over their own feet as they sprint towards you with vigour.]]}}},
{track = 3, texts = {{text = [[They skid to a stop in front of you and pull you into a hug before you can react, seeming overjoyed.]]}}},
{track = 3, texts = {{text = [["]] .. Name_caps .. [[! You're here!"]], style = {"parantajahiisi"}},
{text = [[, they squeal, before releasing you and taking a step back.]]}}},
{track = 3, texts = {{text = [[You realize then who it is - it's ]]}, {text = [[Parantajahiisi]], style = {"parantajahiisi"}}, {text = [[, the healer, looking better than ever;
]] .. a["Their"] .. [[ armor is freshly polished, shining a radiant pink.]]}}},
{track = 3, texts = {{text = [["I've been waiting for you... Come on, come on, there's so much to see!"]], style = {"parantajahiisi"}}}},
{track = 3, texts = {{text = a["They"] .. Plural(a["They"], " grab your arm and begin ", " grabs your arm and begins ") .. [[to drag you along, to the very middle of the plaza.
An enormous blue crystal lies atop a pillar in front of you, providing a subtle glow to the surrounding area.]]}}},
{track = 3, texts = {{text = [["So much happened so fast, it's all kind of a blur...
...B-but, in short... The Gods realized no one was fighting anymore, so we all moved up to the surface!]], style = {"parantajahiisi"}}}},
{track = 3, texts = {{text = [[Those Holy Mountains that separated us all... just sort of disintegrated, I think.]], style = {"parantajahiisi"}}}},
{track = 3, texts = {{text = [[Everyone left a lot behind... But, we've all been figuring things out up here.
And the sun, the sun...! Oh, it's so beautiful..."]], style = {"parantajahiisi"}}}},
{track = 3, texts = {{text = a["They're"] .. [[ obviously elated, glancing eagerly between you and the sunrise in the distance, when ]] .. a["they"] .. [[ turn to notice two figures approaching.]]}}},
{track = 3, texts = {{text = [[You instinctively scowl when you notice who they are: ]]}, {text = "Kranuhiisi", style={"kranuhiisi"}}, {text = " and "}, {text = "Stendari", style={"stendari"}},
{text = ". They both look rather grumpy to see such a cheerful reunion happening without them."}}},
{track = 3, texts = {{text = [["Oi! What's all the commotion? Didja forget you weren't the only person in town, Pinky?"]], style={"kranuhiisi"}}}},
{track = 3, texts = {{text = [["Heh.. Hey, maybe we should give them some time alone, y'know...
They're probably delirious from staying up all night in the plaza."]], style={"stendari"}}}},
{track = 3, texts = {{text = [["H-hey! That's not true..." ]], style = {"parantajahiisi"}}, {text = a["they"] .. Plural(a["they"], " say, ", " says, ") .. "in a flustered tone that implies the opposite."}}},
{track = 3, texts = {{text = [["Well, someone's gotta teach 'em about ]], style={"kranuhiisi"}}, {text = [[encounters]], style={"info"}},
{text = [[, and I doubt Pinky here is confident enough to get to it within the week..."]], style={"kranuhiisi"}}}},
{track = 3, texts = {{text = [["Oh, don't be so hot-headed, Kranuhiisi..."]], style={"stendari"}}, {text = [[ Stendari says with an eye-roll.]]},
{text = [[
"Let's just let ]] .. Name_caps .. [[ decide."]], style={"stendari"}}}},
{track = 3, texts = {{text = [[Parantajahiisi nods gently, more to ]] .. a["themself"] .. [[ than to anyone else.
Kranuhiisi scoffs, but relents with a shrug. ]]}, {text = [["Fine, I guess..."]], style={"kranuhiisi"}}}},
{track = 3, texts = {{text = b["They"] .. [[ turn to focus their attention on you now, looking slightly less combative now that ]] .. b["they've"] .. [[ stopped bickering with the healer.
Stendari smirks slightly as ]] .. c["they"] .. Plural(c["they"], " stand beside ", " stands beside ") .. b["them"] .. [[, as enthusiastic to hear your response as Parantajahiisi is anxious.]]}}},
{track = 3, texts = {{text = b["They"] .. [[ shrug again, acting nonchalantly about the matter.
]]}, {text = [["Hey, only one of us three can chug a whole bottle of sima in ten seconds or less. Just saying."]], style={"kranuhiisi"}}},
choices = {
    {name = "Parantajahiisi", location = "left", gototrack = 6},
    {name = "Kranuhiisi", location = "top", gototrack = 7},
    {name = "Stendari", location = "right", gototrack = 8},
    {name = "No one", location = "bottom", gototrack = 9},
}},

}