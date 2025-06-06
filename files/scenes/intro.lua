dofile("mods/noiting_simulator/files/scripts/characters.lua")

SCENE = {
{texts = {{text = [[The Sampo is placed upon the altar.]]}}},
{texts = {{text = [[Day and night passes...
...As the New Peace falls upon the land.]]}}},
{texts = {{text = [[A weight is lifted. From you... and from the Earth.
A deep-rooted curse, finally overcome...]]}}},
{texts = {{text = [[You hear a calling from deep below... from the Laboratory.
The creatures stare as you sprint by. Their eyes have a different look to them that you barely see.]]}}},
{texts = {{text = [[You make it to the final Holy Mountain and dash forward to meet Kolmisilmä.
But, just as you leave The Laboratory's Holy Mountain... the weight of the world finally takes its toll on you.]]}}},
{texts = {{text = [[You collapse from exhaustion onto the hard brickwork flooring.
Despite everything, you find that your eyes are beginning to close...]]}}},
{texts = {{text = [[. . .
A long time passes... as you take a well-deserved nap.]], forcetickrate = -2}}},
{texts = {{text = [[]], forcetickrate = -2}}},

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
{texts = {{text = [[Farewell for now, Knower. Good luck on your journey.]], character = "Kolmi"}}, sendto = {{file = "locations/lab.lua"}}},
}