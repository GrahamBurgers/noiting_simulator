dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
local k = Pronouns["Kolmi"]
local w = Pronouns["Jattimato"]
local r = Pronouns["Raukka"]
SCENE = {

{track = "main", texts = {{text = [[
You're in The Laboratory.
]], style = {"location"}},
{text = [[Kolmisilmä]], style = {"interact"}}, {text = [[ looms above you.
Your ]], style = {"info"}}, {text = [[Kammi]], style = {"interact"}}, {text = [[ is west of here. ]], style = {"info"}},
{text = [[Jättimato]], style = {"interact"}}, {text = [[ is east of here.]], style = {"info"}}},
choices = {
    {name = "Kammi", position = "left", gototrack = "Kammi"},
    {name = "Kolmisilmä", position = "middle", gototrack = "kolmi"},
    {name = "Jättimato", position = "right", gototrack = "worm"},
}},
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
A slightly dusty ]], style = {"info"}}, {text = [[calendar]], style = {"interact"}}, {text = [[ hangs on the wall.]], style = {"info"}}},
choices = {
    {name = "Back", position = "right", gototrack = "main", gotoline = 1},
    {name = "Calendar", position = "middle", gototrack = "Calendar"},
}},

{track = "Calendar", texts = {{text = [[The calendar displays this week's events. You don't remember writing any of this down.
]], style = {"info"}}, {text = [[Wednesday]], style = {"location"}}, {text = [[ is marked with a drawing of a bonfire atop a familiar island.
]], style = {"info"}}, {text = [[Thursday]], style = {"location"}}, {text = [[ is marked with several raindrops.
]], style = {"info"}}, {text = [[Friday]], style = {"location"}}, {text = [[ is marked with a picture of a bottle.
]], style = {"info"}}, {text = [[Saturday]], style = {"location"}}, {text = [[ is marked with "DOUBLE LOVE".
]], style = {"info"}}, {text = [[Sunday]], style = {"location"}}, {text = [[ is marked with "FESTIVAL" in bold text.
Smaller text beneath reads ">80% LOVE".]], style = {"info"}}}},
{track = "Calendar", setscene = {track = "Kammi", line = 1}},

{track = "KolmiFast", texts = {{text = [[You approach Kolmisilmä. ]] .. k["They"] .. Plural(k["They"], " look ", " looks ") .. [[somewhat amused to see you approaching.]]}}},
{track = "KolmiFast", texts = {{text = [["Eh...? Back so soon, Knower? If you're pining after me, I'm afraid you'll be sorely disappointed...]], style = {"kolmi"}}}},
{track = "KolmiFast", texts = {{text = [[I'm rather too large to travel to any parties.]], style = {"kolmi"}}}},
{track = "KolmiFast", texts = {{[[However, I won't simply be napping while you're off adventuring.
As usual, I've been gathering knowledge... This time, about our ]], style = {"kolmi"}}, {text = [[new world]], style = {"info"}}, {text = [[.]], style = {"kolmi"}},}},
{track = "KolmiFast", setscene = {track = "KolmiReveal"}},

{track = "KolmiSlow", texts = {{text = [[You approach Kolmisilmä. ]] .. k["They"] .. Plural(k["They"], " stare ", " stares ") .. [[down at you intently as you approach.]]}}},
{track = "KolmiSlow", texts = {{text = [["Hello again, Knower. I hope you've had a pleasant day.]], style = {"kolmi"}}}},
{track = "KolmiSlow", texts = {{text = [[Ah, don't give me that look... I've not been bored while you've been away.
As usual, I've been gathering knowledge... This time, about our ]], style = {"kolmi"}}, {text = [[new world]], style = {"info"}}, {text = [[.]], style = {"kolmi"}},}},
{track = "KolmiSlow", setscene = {track = "KolmiReveal"}},

{track = "KolmiReveal", texts = {{text = [[Ah! That made your eyes light up quite nicely. I had a feeling you might be curious.]], style = {"kolmi"}}}},
{track = "KolmiReveal", texts = {{text = [[I've accumulated quite a bit of knowledge after all this time...
I'd certainly be willing to share some with you.]], style = {"kolmi"}}}},
{track = "KolmiReveal", texts = {{text = [[You may ask me about ]], style = {"kolmi"}}, {text = [[one topic per day]], style = {"info"}}, {text = [[.
(Any more, and I fear I may start rambling...)]], style = {"kolmi"}}}},
{track = "KolmiReveal", setscene = {track = "TopicHiisi"}}, -- !!!

{track = "TopicWorms", texts = {{text = [["Ah, the worms... What strange and delightful creatures.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[It's quite hard to reason with them, given they're... concerningly gluttonous.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[After the peace that you brought upon us, it was as if a weight was lifted from everyone. Including the worms...
They began to run wild. If left alone for too long, we wouldn't have much of a surface to return to.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[The old Holy Mountains didn't have much a purpose anymore. So some of the folks from the surface gathered up all the Worm Crystals.
We fused them together, and put the new crystal in the middle of the plaza. Admittedly, I'm not quite sure myself how it worked...]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[But we now have a circle of protection that separates us from the worms' hunger.
Except for Jättimato here, that is... We have a special arrangement, you see.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[(Jättimato, ah... eats our leftovers.
In exchange, ]] .. w["they"] .. Plural(w["they"], " provide ", " provides ") .. [[transportation for us using the worm-tunnels left behind.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[I wouldn't recommend you bring it up to ]] .. w["them"] .. [[...
Worms hardly think once, so thinking twice might be too much for ]] .. w["them"] .. [[ to handle.)]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[I'm not quite sure of the whereabouts of any other worms you might know.]], style = {"kolmi"}}}},
{track = "TopicWorms", texts = {{text = [[They likely ran off to feast on whatever they could find up on the surface, outside the influence of our Worm Crystal...
I'd recommend you, ah... don't go looking for them, or you'll likely become worm chow.]], style = {"kolmi"}}}},

{track = "TopicAlchemists", texts = {{text = [["Ah... the Alchemists. What an unfortunate group they were...]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[You used to be one of them, eh? You certainly look the part.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[They searched and searched for their whole existence... searching for a secret no one deserved to bear.
The object of obsession of them and many, many others before them: Eternal life.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[In the end, they learned something terrible... Something that none of them could forget once it had been unearthed.
They got what they wanted, one could say... Though it was a terrible curse upon all of them.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[Each person that learned the secret eventually succumbed to their own desires and grew monstrous...
Each person except you, it seems.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[I will admit, self-inflicted amnesia is certainly a clever solution to such a problem...
Though I do hope you're feeling better now.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[...Ah, yes... I doubt you came here for a history lesson, nor for your biography to be written.
My apologies for the tangent.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[These days, the Alchemists... Ah. They're resting peacefully.]], style = {"kolmi"}}}},
{track = "TopicAlchemists", texts = {{text = [[You may visit them at the graveyard, if you'd like.
...I think that... they'd like that.]], style = {"kolmi"}}}},

{track = "TopicHiisi", texts = {{text = [["Ah, the Hiidet... That's the plural of Hiisi, if you didn't know. Interesting folks they are indeed.]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[Once a lively and diverse people, they turned to violence and alcohol when the world around them began to turn hostile.]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[They, like many others, became intensely territorial, using whatever they could get their hands on to make sure outsiders stay out.]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[Nowadays, they've mostly calmed down, though their unique taste for drinks has still earned them quite a name up on the surface.]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[Raukka is the bartender up there, and I've heard great things about them...]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[They've began serving exclusively non-alcoholic drinks recently, citing a few too many messes made on the premises.
The other Hiidet don't seem to mind, though; Raukka's an expert at serving drinks of all kinds.
I'm not certain that they've even noticed the difference...]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[Ah... They also were *supposed* to cease all weapon usage.
]], style = {"kolmi"}}}},
{track = "TopicHiisi", texts = {{text = [[]], style = {"kolmi"}}}},

{track = "any", texts = {{text = [[...
...Ahem. I suppose I've talked long enough about that.
Run along now, Knower. You've memories to make."]], style = {"kolmi"}}}},
{track = "any", meet = "Kolmi", setscene = {file = "locations/lab.lua"}},
}