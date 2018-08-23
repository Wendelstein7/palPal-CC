--[[
  palPal by HydroNitrogen
  Licenced under MIT
  Copyright (c) 2018 Wendelstein7 (a.k.a. HydroNitrogen)
  See: https://github.com/Wendelstein7/palPal-CC
  ]]

local palPal = {
  ["name"] = "palPal",
  ["author"] = "HydroNitrogen",
  ["date"] = "2018-08-23",
  ["version"] = 1,
  ["url"] = "https://github.com/Wendelstein7/palPal-CC"
}

local function hexToRGB(hex)
  local r = bit.brshift(bit.band(0xFF0000, hex), 16) / 255
  local g = bit.brshift(bit.band(0xFF00, hex), 8) / 255
  local b = bit.band(0xFF, hex) / 255
  return r, g, b
end

local function toRGBTable(r, g, b)
  return { ["r"] = r, ["g"] = g, ["b"] = b }
end

local function fromRGBTable(t)
  return t.r, t.g, t.b
end

local function expect(func, n, arg, expected)
  if type(arg) == expected then
    return true
  else
    return error(("%s: bad argument #%d (expected %s, got %s)"):format(func, n, expected, type(arg)), 3)
  end
end

local function expectTerm(func, n, t)
  if type(t) == "table" and type(t.setPaletteColour) == "function" and type(t.getPaletteColour) == "function" then
    return true
  else
    return error(("%s: bad argument #%d (expected terminal object)"):format(func, n), 3)
  end
end

-- set palette colour c in palette p to r, g, b or hex
function palPal.setPaletteColour(p, c, r, g, b)
  if g == nil or b == nil then
    expect("setPaletteColour", 1, p, "table")
    expect("setPaletteColour", 2, c, "number")
    expect("setPaletteColour", 3, r, "number")

    p[c] = toRGBTable(hexToRGB(r))
    return p
  else
    expect("setPaletteColour", 1, p, "table")
    expect("setPaletteColour", 2, c, "number")
    expect("setPaletteColour", 3, r, "number")
    expect("setPaletteColour", 4, g, "number")
    expect("setPaletteColour", 5, b, "number")
    
    p[c] = toRGBTable(r, g, b)
    return p
  end
end

-- get palette colour c from palette p
function palPal.getPaletteColour(p, c)
  expect("getPaletteColour", 1, p, "table")
  expect("getPaletteColour", 2, c, "number")

  return fromRGBTable(p[c])
end

-- storing palette from terminal t
function palPal.storePalette(t)
  expectTerm("storePalette", 1, t)

  local p = {}
  local c = 1
  repeat
    p[c] = toRGBTable(t.getPaletteColour(c))
    c = c * 2
  until c > 32768
  return p
end

-- loading palette p to terminal t
function palPal.loadPalette(t, p)
  expectTerm("loadPalette", 1, t)
  expect("loadPalette", 2, p, "table")

  local c = 1
  repeat
    t.setPaletteColour(c, fromRGBTable(p[c]))
    c = c * 2
  until c > 32768
end

-- for EN-US users
palPal.getPaletteColor = palPal.getPalleteColour
palPal.setPaletteColor = palPal.setPalleteColour

return palPal
