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
{id = "worm", texts = {{text = [["Knower! You're here!"]], style = {"parantajahiisi"}},
{text = [[, they squeal, before releasing you and taking a step back.]]}}},
{id = "worm", texts = {{text = [["I've been waiting for you... Come on, come on, there's so much to see!"]], style = {"parantajahiisi"}}}},
{id = "worm", texts = {{text = P("Parantajahiisi", {she = "She grabs your arm and begins ", he = "He grabs your arm and begins ", they = "They grab your arm and begin ", it = "It grabs your arm and begins "}) .. [[to drag you along, to the very middle of the plaza.
An enormous blue crystal lies atop a pillar in front of you, providing a subtle glow to the surrounding area.]]}}},
}