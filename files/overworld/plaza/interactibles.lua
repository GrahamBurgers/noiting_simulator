---@return number
function Init(id)
    local interactibles = {
        ["ball"] = {track = 1},
        ["plant"] = {track = 2},
        ["spider"] = {track = 3},
    }
    return interactibles[id]["track"]
end

SCENE = {

{track = 1, texts = {{text = [[ball]]}}},
{track = 2, texts = {{text = [[plant]]}}},
{track = 3, texts = {{text = [[sp.ider]]}}},

{track = 0, behavior = "freeplayer"}
}