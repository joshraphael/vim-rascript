// Sample RAScript fixture for vim-rascript syntax testing.
// TODO: keep this file covering every highlighted construct.
// FIXME XXX  <- todo markers inside comments

/*
 * Block comment
 * spanning multiple lines. TODO inside block.
 */

// ---- numbers & booleans ----
lives_addr  = 0x001F
score_addr  = 0x00C4A0
max_lives   = 9
speed       = 1.5
is_hardcore = true
is_debug    = false

// ---- strings & escapes ----
greeting = "Hello, world"
quoted   = "She said \"hi\"\n"

// ---- arrays & dictionaries ----
stages = [1, 2, 3, 4]
stage_names = {
    1: "Green Hill",
    2: "Marble Zone",
    3: "Spring Yard",
}

// ---- memory accessors ----
function lives()        => byte(lives_addr)
function score()        => dword(score_addr)
function level()        => word(0x0010)
function timer()        => tbyte(0x0020)
function flags()        => bit3(0x0030) + low4(0x0031) + high4(0x0032)
function bits()         => bit(5, 0x0033) + bitcount(0x0034)
function be_vals()      => word_be(0x40) + tbyte_be(0x43) + dword_be(0x46)
function floats()       => float(0x50) + float_be(0x54) + mbf32(0x58) + mbf32_le(0x5C)
function doubles()      => double32(0x60) + double32_be(0x64)

// ---- control flow ----
function in_game(stage)
{
    if (stage == 0 || stage > 7)
        return always_false()
    else if (stage != 3 && !is_debug)
        return byte(0x0010) >= 1
    else
        return always_true()
}

// ---- operators ----
function math_ops(a, b)
{
    x = a + b - a * b / 2 % 3
    y = a & 0xFF | b ^ 0x0F
    z = ~a
    return x <= y
}

// ---- modifiers ----
function died() => lives() < prev(lives())

for stage in range(1, 4)
{
    // ---- definition functions with named params ----
    achievement(
        title = "Clear Stage " + stage,
        description = format("Clear stage {0} without dying", stage),
        points = 10,
        id = 1000 + stage,
        badge = "00000",
        trigger = in_game(stage) &&
                  once(level() == stage) &&
                  never(died()) &&
                  unless(bcd(byte(0x70)) == 99) &&
                  repeated(3, prior(byte(0x71)) == 1) &&
                  trigger_when(byte(0x72) == 1) &&
                  measured(tally(5, byte(0x73) == 1)) &&
                  invert(byte(0x74)) == 0
    )
}

leaderboard(
    title = "High Score",
    description = "Highest score",
    start = byte(0x80) == 1,
    cancel = byte(0x80) == 0,
    submit = byte(0x81) == 1,
    value = score(),
    format = "SCORE"
)

// ---- built-in helpers ----
total     = length(stages)
array_push(stages, 5)
last      = array_pop(stages)
doubled   = array_map(stages, (s) => s * 2)
has_three = array_contains(stages, 3)
has_key   = dictionary_contains_key(stage_names, 2)
any_dead  = any_of(stages, s => byte(0x90 + s) == 0)
all_alive = all_of(stages, s => byte(0x90 + s) > 0)
none_set  = none_of(stages, s => bit0(0xA0 + s) == 1)
total_hp  = sum_of(stages, s => byte(0xB0 + s))
counted   = tally_of(stages, 3, s => byte(0xC0 + s) == 1)
best      = max_of(stages, s => byte(0xD0 + s))
part      = substring(greeting, 0, 5)
name_ok   = ascii_string_equals(0xE0, "SONIC")
uni_ok    = unicode_string_equals(0xF0, "SONIC")

// ---- rich presence ----
rich_presence_macro("Number", lives())
rich_presence_conditional_display(byte(0x80) == 0, "Title Screen")
rich_presence_display("{0} - Lives: {1} - Score: {2}",
    rich_presence_lookup("Stage", level(), stage_names, fallback = "Unknown"),
    rich_presence_value("Number", lives()),
    rich_presence_value("Score", score(), format = "SCORE")
)
