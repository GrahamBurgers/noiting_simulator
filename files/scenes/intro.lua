dofile("mods/noiting_simulator/files/scripts/characters.lua")

SCENE = {

{track = "main", texts = {{text = [[]] .. Name_caps .. [[!]], style = {"kolmi"}, forcetickrate = -10}}},
{track = "main", texts = {{text = [[Open your eyes, little one...
You've been asleep for far too long.]], style = {"kolmi"}, forcetickrate = -3}}},
{track = "main", texts = {{text = [[
Ah, there you are.
It's good to see you back on your feet; I was a tad concerned.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[You travelled all the way down here and collapsed just like that.
I suppose mortality can be stressful.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Little Knower to Be... or, I suppose I should just call you 'Knower' now. Heh.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[After all, it was your knowledge that brought peace to this world.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Ahem. Regardless. You look well-rested now, so shall I fill you in on the news?]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[...Ah, right. You don't speak. I suppose I'll take that as a 'yes'.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[
Well, in celebration of our newfound peace... I'll be throwing a party in ]], style = {"kolmi"}}, {text = [[one week]], style = {"info"}}, {text = [[.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Everyone's invited, of course... And I've heard quite a few of the locals are hoping to see you there.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[In fact... Many of them look up to you after your little feat of great knowledge.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Several even mentioned offering themselves as a date for the party...
Ahem. I shan't gossip.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Regardless. You've got seven days to get to know the locals. Enjoy yourself, why don't you?]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[I wouldn't want to stress you further, after you've worked so hard for us all...]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[
Ah, you probably don't want to listen to me blather on much longer. Go on now.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[The worm-tunnel to the east will take you to the surface. Jättimato will be glad to assist you.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[When it gets dark, return here. There's a Kammi in the Holy Mountain west of here for you to rest in.]], style = {"kolmi"}}}},
{track = "main", texts = {{text = [[Farewell for now, Knower. Good luck on your journey.]], style = {"kolmi"}}}},
{track = "main", setscene = {file = "locations/lab.lua"}, meet = "Kolmi"}
}