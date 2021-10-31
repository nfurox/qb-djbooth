Config = {}

Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'vanilla', -- Required job to use booth
        ['radius'] = 30, -- The radius of the sound from the booth
        ['coords'] = vector3(131.36, -1286.94, 29.26) -- Where the booth is located
    },
    ['thelost'] = {
        ['job'] = 'thelost',
        ['radius'] = 20,
        ['coords'] = vector3(983.79, -132.3, 78.89)
    }
}
