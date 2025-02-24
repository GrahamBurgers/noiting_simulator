dofile("mods/noiting_simulator/files/scripts/characters.lua")

SCENE = {
{texts = {{text = [[...
The Sampo is placed upon the altar.
Day and night passes...]]}}},
{texts = {{text = [[A weight is lifted. From you... and from the Earth.
A deep-rooted curse, finally overcome...]]}}},
{texts = {{text = [[You feel a calling from deep below... from the Laboratory.]]}}},

{texts = {{text = [[]] .. Name_caps .. [[!]], character = "Kolmi", forcetickrate = -10}}},
{texts = {{text = [[Open your eyes, little one...
You've been asleep for far too long.]], character = "Kolmi", forcetickrate = -3}}},
{texts = {{text = [[
Ah, there you are.
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
{texts = {{text = [[Farewell for now, Knower. Good luck on your journey.]], character = "Kolmi"}}},
{setscene = {file = "locations/lab.lua"}, meet = "Kolmi"}
}