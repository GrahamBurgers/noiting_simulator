dofile("mods/noiting_simulator/files/scripts/characters.lua")

SCENE = {
{id = "main", texts = {{text = [[You place the Sampo upon the altar.]], forcetickrate = -2}}},
{texts = {{text = [[Eleven orbs of true knowledge... You channel their power.]]}}},
{texts = {{text = [[Your offering is accepted.
The sky begins to turn faster around you.]]}}},
{texts = {{text = [[The Sun and Moon spin around you relentlessly...
Clouds whip by at an alarming speed.]], forcetickrate = -2}}},
{texts = {{text = [[Day and night passes...
...As the New Peace falls upon the land.]]}}},
{bookmark = {file = "bookmark.lua"}},
{texts = {{text = [[...You faint.]], forcetickrate = -2}}},
{texts = {{text = [[. . .
A long time passes... as you take a well-deserved nap.]], forcetickrate = -2}}},
{texts = {{text = [[Then, faintly, you feel a sensation, while teetering between dreaming and awake...]], forcetickrate = -2}}},
{texts = {{text = [[...Someone's set a pillow beneath your head.]]}}},
{texts = {{text = [[A blanket is being draped over you.]]}}},

{texts = {{text = [[Open your eyes, little one...
You've been asleep for far too long.]], character = "Kolmi", forcetickrate = -2}}},
{texts = {{text = [[You open your bleary eyes and stand back up with some effort, then look up to see a familiar face...]], forcetickrate = -2}}},
{texts = {{text = [[Ah, there you are.
It's good to see you back on your feet; I was a tad concerned.]], character = "Kolmi"}}},
{texts = {{text = [[You travelled all the way down here and collapsed just like that.
I suppose mortality can be stressful.]], character = "Kolmi"}}},
{texts = {{text = [[Little Knower to Be... or, I suppose I should just call you 'Knower' now. Heh.]], character = "Kolmi"}}},
{texts = {{text = [[After all, it was your knowledge that brought peace to this world.]], character = "Kolmi"}}},
{texts = {{text = [[Ahem. Regardless. You look well-rested now, so shall I fill you in on the news?]], character = "Kolmi"}}},
{texts = {{text = [[...Ah, right. You don't speak. I suppose I'll take that as a 'yes'.]], character = "Kolmi"}}},
{texts = {{text = [[
Well, in celebration of our newfound peace... I'll be throwing a party in ]], character = "Kolmi"}, {text = [[one week]], style = {"info"}}, {text = [[.]], character = "Kolmi"}}},
{texts = {{text = [[Everyone's invited, of course... And I've heard quite a few of the locals are hoping to see you there.]], character = "Kolmi"}}},
{texts = {{text = [[In fact... Many of them look up to you after your little feat of great knowledge.]], character = "Kolmi"}}},
{texts = {{text = [[Several even mentioned offering themselves as a date for the party...
Ahem. I shan't gossip.]], character = "Kolmi"}}},
{texts = {{text = [[Regardless. You've got seven days to get to know the locals. Enjoy yourself, why don't you?]], character = "Kolmi"}}},
{texts = {{text = [[I wouldn't want to stress you further, after you've worked so hard for us all...]], character = "Kolmi"}}},
{texts = {{text = [[
Ah, you probably don't want to listen to me blather on much longer. Go on now.]], character = "Kolmi"}}},
{texts = {{text = [[The worm-tunnel to the east will take you to the surface. Jättimato will be glad to assist you.]], character = "Kolmi"}}},
{texts = {{text = [[When it gets dark, return here. There's a Kammi in the Holy Mountain west of here for you to rest in.]], character = "Kolmi"}}},
{texts = {{text = [[Farewell for now, Knower. Good luck on your journey.]], character = "Kolmi"}}, sendto = {{file = "locations/lab.lua", line = 1}}},
}