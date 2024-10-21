dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local a = Pronouns["Parantajahiisi"]
local b = Pronouns["Kranuhiisi"]
local c = Pronouns["Ukko"]
SCENE = {
    {track = 1, text = [[There's a giant worm here. Strangely enough, it's not moving an inch at the moment.]]},
    {track = 1, text = [[It looks no different from the other worms you've seen before...
    aside from the large yellow bow that's been decoratively tied to the back of its head.]]},
    {track = 1, text = [[You take a step closer, and it seems to notice you for the first time.
    Its enormous yellow eye slowly pivots to gaze at you. Your hair begins to stand on end.]]},
    {track = 1, text = [[And yet... It stays obediently still.]]},
    {track = 1, text = [[It doesn't, as you'd typically expect, lunge towards you with the intent to swallow you whole.
    It just stares for a long moment... as if expecting something from you.]],
        choices = {
            {name = "Back off", location = "left", gototrack = 2},
            {name = "Mount", location = "right", gototrack = 3},
        }},
    {track = 2, text = [[You quickly back off, intimidated by the worm's gaze.
    It returns to staring at the wall blankly, completely unfazed by your actions.]]},
    {track = 3, text = [[You take a deep breath, take a step forward, brace yourself, and...]]},
    {track = 3, text = [[...Before you know it, you're on the worm's back.
    From here, the blue hair that coats its body actually feels quite soft.]]},
    {track = 3, text = [[Then, a quiet rumbling... as the worm begins gaining speed.
    Slowly at first, but then faster and faster, until the world begins to blur around you.]]},
    {track = 3, text = [[Before long, you find yourself desperately clutching onto the worm's bow with both hands.
    You stay like that for what seems like an eternity, holding on for dear life, and then...]]},
    -- awesome gfx here
    {track = 3, text = [[Sunlight covers your body and fills your eyes as the worm breaks through to the surface.]]},
    {track = 3, text = [[By the time you realize you're in the air, you've already landed, with a loud thump that nearly knocks the wind out of you.]]},
    {track = 3, text = [[You're still moving rather fast, skating along the grassy surface now, kicking up dirt and dust as you go.
    Buildings come into view, and the worm finally begins to slow down upon seeing them.]]},
    {track = 3, text = [[It takes a bit of effort to hold down your nausea for the rest of the trip... but you manage.
    Eventually, the worm slows to a stop, causing a cloud of dust to billow out around you.
    You dismount slowly, feeling somewhat dizzy.]]},
    {track = 3, text = [[You're now standing in some sort of plaza.
    It's surprisingly lively, with figures standing in the distance and chatting casually.]]},
    {track = 3, text = [[And yet, before you've had the time to get your bearings further...
    One of the figures begins to approach you. It looks like they're running.]]},
    -- hiisi healer is the first to greet the player
    {track = 3, text = [[Their boots are loud on the tile floor, and they nearly trip over their own feet as they sprint towards you with vigour.]]},
    {track = 3, text = [[They skid to a stop in front of you and pull you into a hug before you can react, seeming overjoyed.]]},
    {track = 3, text = table.concat({[["]], Name_caps, [[! You're here!", they squeal, before releasing you and taking a step back.]]})},
    {track = 3, text = table.concat({[[You realize then who it is - it's Parantajahiisi, the healer, looking better than ever;
    ]], a["Their"], [[ armor is freshly polished, shining as pink as ever.]]})},
    {track = 3, text = {[["Hi! I've been waiting for you, I-"]]}},
    {track = 3, text = {[["Hi! I've been waiting for you, I-"]]}},
}