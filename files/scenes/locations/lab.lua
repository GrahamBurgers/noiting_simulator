dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local k = Pronouns["Kolmi"]
local w = Pronouns["Jattimato"]
SCENE = {

{track = "main", texts = {{text = [[
You're in The Laboratory.
]], style = {"location"}},
{text = [[Kolmisilmä]], click = {track = "kolmi"}}, {text = [[ looms above you.
Your ]], style = {"info"}}, {text = [[Kammi]],  click = {track = "Kammi"}}, {text = [[ is west of here. ]], style = {"info"}},
{text = [[Jättimato]], click = {track = "worm"}}, {text = [[ is east of here.]], style = {"info"}}}},
{track = "worm", setscene = {file = "intro2.lua"}},
{track = "kolmi", func = function()
    if Geterate("kolmi_wisdom", 2) > 1 then
        Track("KolmiSeen")
    else
        if GlobalsGetValue("NS_DAY", "1") and GlobalsGetValue("NS_TIME_OF_DAY") ~= "Night" then
            Track("KolmiFast")
        else
            Track("KolmiSlow")
        end
    end
end},
{track = "Kammi", texts = {{text = [[
You're in your Kammi.
]], style = {"location"}}, {text = [[The brickwork that surrounds it has grown mossy with time.
A ]], style = {"info"}}, {text = [[calendar]], click = {track = "Calendar"}}, {text = [[ hangs on the wall.
]], style = {"info"}}, {text = [[Back]], click = {track = "main", line = 1}}}},

{track = "Calendar", texts = {{text = [[The calendar displays this week's events. It's strangely new-looking compared to the rest of the room.
]], style = {"info"}}, {text = [[Wednesday]], style = {"location"}}, {text = [[ is marked with a drawing of a bonfire atop a familiar island.
]], style = {"info"}}, {text = [[Thursday]], style = {"location"}}, {text = [[ is marked with several raindrops.
]], style = {"info"}}, {text = [[Friday]], style = {"location"}}, {text = [[ is marked with a picture of a bottle.
]], style = {"info"}}, {text = [[Saturday]], style = {"location"}}, {text = [[ is marked with "DOUBLE LOVE".
]], style = {"info"}}, {text = [[Sunday]], style = {"location"}}, {text = [[ is marked with "FESTIVAL".
]], style = {"info"}}, {text = [[Back]], click = {track = "main", line = 1}}}},

{track = "KolmiFast", texts = {{text = [[You approach Kolmisilmä. ]] .. k["They"] .. Plural(k["They"], " look ", " looks ") .. [[somewhat amused to see you approaching.]]}}},
{track = "KolmiFast", texts = {{text = [[Eh...? Back so soon, Knower? If you're pining after me, I'm afraid you'll be sorely disappointed...]], character = "Kolmi"}}},
{track = "KolmiFast", texts = {{text = [[I'm rather too large to travel to any parties.]], character = "Kolmi"}}},
{track = "KolmiFast", texts = {{text = [[However, I won't simply be napping while you're off adventuring.
As usual, I've been gathering knowledge... This time, about our ]], character = "Kolmi"}, {text = [[new world]], style = {"info"}}, {text = [[.]], character = "Kolmi"},}},
{track = "KolmiFast", setscene = {track = "KolmiReveal"}},

{track = "KolmiSlow", texts = {{text = [[You approach Kolmisilmä. ]] .. k["They"] .. Plural(k["They"], " stare ", " stares ") .. [[down at you intently as you approach.]]}}},
{track = "KolmiSlow", texts = {{text = [[Hello again, Knower. I hope you've had a pleasant day.]], character = "Kolmi"}}},
{track = "KolmiSlow", texts = {{text = [[Ah, don't give me that look... I've not been bored while you've been away.
As usual, I've been gathering knowledge... This time, about our ]], character = "Kolmi"}, {text = [[new world]], style = {"info"}}, {text = [[.]], character = "Kolmi"}}},
{track = "KolmiSlow", setscene = {track = "KolmiReveal"}},

{track = "KolmiReveal", texts = {{text = [[Ah! That made your eyes light up quite nicely. I had a feeling you might be curious.]], character = "Kolmi"}}},
{track = "KolmiReveal", texts = {{text = [[I've accumulated quite a bit of knowledge after all this time...
I'd certainly be willing to share some with you.]], character = "Kolmi"}}},
{track = "KolmiReveal", texts = {{text = [[You may ask me about ]], character = "Kolmi"}, {text = [[one topic per day]], style = {"info"}}, {text = [[.
(Any more, and I fear I may start rambling...)]], character = "Kolmi"}}},
-- add topic chooser here later

{track = "TopicWorms", texts = {{text = [[Ah, the worms... What strange and delightful creatures.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[It's quite hard to reason with them, given they're... concerningly gluttonous.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[After the peace that you brought upon us, it was as if a weight was lifted from everyone. Including the worms...
They began to run wild. If left alone for too long, we wouldn't have much of a surface to return to.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[The old Holy Mountains didn't have much a purpose anymore. So some of the folks from the surface gathered up all the Worm Crystals.
We fused them together, and put the new crystal in the middle of the plaza. Admittedly, I'm not quite sure myself how it worked...]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[But we now have a circle of protection that separates us from the worms' hunger.
Except for Jättimato here, that is... We have a special arrangement, you see.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[Jättimato, ah... eats our leftovers.
In exchange, ]] .. w["they"] .. Plural(w["they"], " provide ", " provides ") .. [[transportation for us using the worm-tunnels left behind.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[I wouldn't recommend you bring it up to ]] .. w["them"] .. [[...
Worms hardly think once, so thinking twice might be too much for ]] .. w["them"] .. [[ to handle.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[I'm not quite sure of the whereabouts of any other worms you might know.]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[They likely ran off to feast on whatever they could find up on the surface, outside the influence of our Worm Crystal...]], character = "Kolmi"}}},
{track = "TopicWorms", texts = {{text = [[I'd recommend you, ah... don't go looking for them unless you plan on becoming worm chow.]], character = "Kolmi"}}},

{track = "TopicAlchemists", texts = {{text = [[Ah... the Alchemists. What an unfortunate group they were...]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[You used to be one of them, eh? You certainly look the part.]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[They searched and searched for their whole existence... searching for a secret no one deserved to bear.
The object of obsession of them and many, many others before them: Eternal life.]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[In the end, they learned something terrible... Something that none of them could forget once it had been unearthed.
They got what they wanted, one could say... Though it was a terrible curse upon all of them.]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[Each person that learned the secret eventually succumbed to their own desires and grew monstrous...]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[It was a horrific sight to see. None of them deserved to suffer such that they did...
But that way they did remain, only until you brought peace upon us all.]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[These days, the Alchemists... Ah. They're resting peacefully.]], character = "Kolmi"}}},
{track = "TopicAlchemists", texts = {{text = [[You may visit them at the cemetery, if you'd like.
...I think that... they'd like that.]], character = "Kolmi"}}},

{track = "TopicHiisi", texts = {{text = [[Ah, the Hiidet... That's the plural of Hiisi, if you were unaware. Interesting folks they are indeed.]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[Once a lively and diverse people, they turned to violence and alcohol when the world around them began to turn hostile.]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[They, like many others, became intensely territorial, using whatever they could get their hands on to make sure outsiders stay out.]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[Nowadays, they've mostly calmed down, though their unique taste for drinks has still earned them quite a name up on the surface.]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[Alkemisti is the bartender up there, and I've heard great things about them...]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[They've began branching out into non-alcoholic drinks recently, citing a few too many messes made on the premises.
The other Hiidet don't seem to mind, though; Raukka's an expert at serving drinks of all kinds.
I'm not certain that they've even noticed the difference...]], character = "Kolmi"}}},
{track = "TopicHiisi", texts = {{text = [[That's about all I've heard of them recently...
As usual, they're figuring out nature, technology and magic in their own clumsy way.
How... charming. I suppose.]], character = "Kolmi"}}},

{track = "any", texts = {{text = [[...Ahem. I suppose I've talked long enough about that.
Run along now, Knower. You've memories to make.
]], character = "Kolmi"}, {text = [[Back]], click = {track = "main", line = 1}}}},
}