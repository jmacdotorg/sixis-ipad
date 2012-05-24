Sixis
=====

# TODO

## Rethink the dice-lock / unlock UI?
  * I'm not convinced about the locking UI. Might be more discoverable to allow only tapping the dice, which makes a _klunk_ sound and draws a little padlock symbol over the die. Tap again to un-klunk. All dice left in that state are animated as sweeping intou the player's safe; the other dice fade away entirely.
  
  In that case, the dice aren't draggable at all. And there'd be no confusion about which dice you can drag out of the safe.

# Overall goals

The iOS version of _Sixis_ will aim towards simulation of playing a copy of the game with physical cards. It will favor a realistic presentation of the cards and other play materials as well as the experience of interacting with them -- no need for bursts of fireworks on success or whatnot.

The simulation involves treating the iPad's surface like a miniature tabletop, with the different players seated on different edges, all looking down at the board together. Various pieces of the game UI specific to certain players will be rotated so that they are oriented rightside-up from those players' perspective. This will be true even when only one human player is present (as in versus-AI or network play), because head-to-head play among local friends shall be the game's intended play style -- though we won't overtly state this.

## Target platform: iPad

The iPad (which is to say "tablet computers", which is to say "the iPad") is much better suited for digital tabletop gameplay than the iPhone. So, for Sixis' initial release, we'll target the iPad as the game's intended platform, with the option of adding iPhone support in a future version if sales and word-of-mouth are both sufficiently good.

The game should run acceptably well on all models of iPad, going back to the first.

## Supported modes: Tabletop & single-player

Connected to the same philosophy driving my decision to initially target iPad only, the first release of Sixis will _not_ feature network support. Network play is a great feature, but supporting the many demands and edge-cases inherent in filling out a network protocol properly is very much a project in itself.

Let's instead put our energy into creating a solid, polished tabletop experience for the iPad, to be enjoyed by a friends and family playing together, with AI-backed solitaire play available as a secondary play mode.

As with the question of supporting non-iPad platforms, if we see demand for it, we can consider adding network-play support later. But by not adding it now, we can ship our first version significantly sooner, and not worry about diffracting our focus too much.

## Game Center integration

Since we're punting on network play, let's do the same with Game Center integration for now, too. Keep it simple!

## And how does Asmadi feel about this?

I approached Chris shyly and even a little apologetically about my thoughts to limit this to iPad. But Chris responded with almost dismissive insistence that Appleseed has full creative control over this app's design.

He recognizes that it's our first major project for this platform and sees the benefits inherent in limiting its scope. I feel quite confident in our continuing to work under this spirit with no danger of putting a strain on the Appleseed-Asmadi partnership.

# Design sketch

## Main Menu

Options include:

 * Play!
     * If a game is in progress, display that game, then overlay it with a dialog asking if you'd like to continue this game or start a new one.
     * Otherwise, go directly to the game-setup screen.
 * Learn
     * Displays a submenu:
         * Read the rules
             * Displays an appropriately adapted scrollable text-view of Chris's rule-sheet for Sixis
             * Adaptations include rewriting as necessary to recognize the iPad format
         * Play a tutorial game
             * If a game is in progress, display a dialog stating that starting a new tutorial game would end that one. Buttons let the user _Play the tutorial_ or _Cancel_.
             * If there's no game in progress (or if the user selects _Play the tutorial_ from that dialog), set up a new tutorial game.
 * Options
     * Music on / off
     * Sound effects on / off
 * About
     * Displays a simple scroll view with credits, legal info, etc.

## Game setup

The setup screen needs to be fast and obvious. It's really easy to get this thing wrong, and most iPad board games I have do a pretty crappy job here. I want to work hard on keeping this screen simple.

This is the essential flow I have in mind (see related sketches):

1. User taps "Play!".
1. App responds with a modal asking how many players there are, giving them three dice to tap: 2, 3 or 4. (Die graphics are cool and thematic and will please Chris.)
1. User taps one of the dice
![How many players?](sixis/raw/master/Sketches/how_many_players.jpg)
1. If it's a four player game, shift to a view that lets you choose between a partnership game or a standard game. Otherwise, skip to the next view.
![Play with teams?](sixis/raw/master/Sketches/play_with_teams.jpg)
1. Modal shifts to a configuration view, essentially a table with one row per player
    * Row contents include:
        * A die, with face 1 - 4 showing. This is interactive! Tap it to bring up a simple color picker containing six swatches, one for each 36-DICE die color.
        * An editable textfield for player name. Defaults to "Player _N_".
        * A two-sectioned button. The labels on the button depict a round smileyface and a square smileyface, respectively. A tiny text label beneath the button displays either "Human" or "Bot", depending on which section is selected.
    * If this is a team game, then the rows will be visually grouped as two pairs.
    * The header for the table has a Back button. Tap it to return to "How many players?"
    * All this is to say that all these views are wrapped in a standard iOS Navigation controller.
![Who's Playing?](sixis/raw/master/Sketches/whos_playing.jpg)
1. Shift to a view to choose a game length:
    * [1] Play just one round _The [1] etc are dice illustrations, btw_
    * Play for [3] rounds
    * Play for [5] rounds
    * Play to 600 points _No dice illos on this row_
![Game Length](sixis/raw/master/Sketches/game_length.jpg)
1. The game starts, going right to the playfield. 

## Playfield

![Loose sketch of playfield areas](sixis/raw/master/Sketches/Table.jpg)

The game takes place on a nice green felt surface. Yes, it will look like the Game Center app, but this is because these two apps are drawing from the same well.

Every round begins with an animation of the cards being dealt from a Sixis deck at the center of the table, in the configuration correct for the current number of players. Then the top card of the deck flips over, becoming the Sixis card itself. _(We can skip all this animation for the prototype, and just paint the cards onscreen.)_ The resulting spread of cards should look just like a real-life Sixis setup, with the cards individually oriented as they appear in the game's printed rules.

We assume that each player is physically (or virtually) seated so that they're looking down at the iPad surface with one of the iPad edges being, from their perspective, the bottom of the display. In a two player game, each player claims one of the iPad's two long edges. A third or a fourth player will claim one of the shorter edges.

Along their own edge, each player can see the following information and controls, representing their very own little Sixis information center.

 * Their name
 * Their score
     * In a one-round game, this says __Score: 60__
     * In the first round of a longer game, this says __Round 1: 60__
     * In any other situation, this is split: __Round 3: 60 | 300 Total__. The _Total_ number increases along with the round score, so that it's an accurate total.
     * In a partnership game, the two partners' scores are simply duplicated with one another, across the table.
 * The "safe", where the player stores locked dice (see below)

All this is presented in a faux-woodgrain strip that surrounds the Sixis table, suggesting that the felt surface is recessed below this border. Very classy.

The view containing all this stuff should fit snugly in the iPad's shorter edges. On the longer edges, scootch this view so it's flush with the left side of the screen (relative to its player). We can fill in the space left over with a logo or something.

As in the physical game, the space between their nearest two "arms" of the Sixis card layout is the space they roll dice in. This is discussed further in "The roll-space", below.
 
## Dice
 
### The safe

Visually, the _safe_ is a recessed strip carved within the player's screen-edge. It's large enough to fit six dice, in a row, snugly. (But with an attractive amount of padding -- use Interface Builder's own aesthetics here.)

The safe itself is not interactive. It just displays the player's locked dice in between rounds.

### The roll-space

As in the physical game, the tabletop region between a player's nearest two "arms" of the Sixis card layout is a space for rolling their own dice. Dice should scatter across this section pleasingly on a roll, instead of just appearing on a grid or something. 

The roll-space serves a secondary purpose as the space where all player-specific messages and controls appear. It gives us an excuse to orient these textviews and controls so it's absolutely unambiguous who should read / poke them, alleviating a problem I've seen in some other iPad games.

Here's the buttons / text that appears in this space, in various circumstances:

 * On the player's own turn...
     * If the player hasn't rolled yet...
         * If the player has no dice locked, there's just "Roll!"
         * If the player has between one and five locked dice, there's "Roll unlocked dice" and "Roll all dice"
         * If the player has six locked dice, there's "Roll nothing!" and "Roll all dice"
     * If the player has rolled...
         * In all circumstances:
             * Display an "End Turn" button.
             * If the player has at least two unlocked dice, display the label "You may lock any of the dice you just rolled."
             * If the player has exactly one unlocked die, display the label "You may lock that die you just rolled."
         * If any cards are available to score or flip, display the label "You may score or flip one card that your dice match."
             * If the player proceeds to score or flip a card, remove that label.
         * If no cards are available to score or flip, display the label "Your dice don't match any cards."
* If a player scores the Sixis card...
    * Clear other labels & buttons in the roll space
    * Display the label "You scored the Sixis card, ending the round."
    * If the game isn't over, display the button "Begin next round"
* If it's a 3- or 4- player game, and a player starts a turn with no cards left...
    * Clear other labels & buttons in the roll space
    * Display the label "All the dealt cards available to you have been scored, so this round has ended."
    * If the game isn't over, display the button "Begin next round"
* If it's a 2-player game, and all cards are red...
    * Leave all other labels & buttons in place
    * Display the label "All remaining cards are red, so you may end this round if you wish."
    * Display the button "End round" next to the existing "End turn" button.
* If it's a 2-player game, and all four cards on one side of the Sixis have been scored...
    * Leave all other labels & buttons in place
    * Display the label "All four cards on one side of the Sixis have been scored, so you may end this round if you wish."
    * Display the button "End round" next to the existing "End turn" button.
* If _all eight_ cards are scored in a 2-player game (leaving only the Sixis)
    * Leave all other labels & buttons in place
    * Display the label "All cards except the Sixis have been scored, so you may end this round if you wish."
    * Display the button "End round" next to the existing "End turn" button.

_(Yes, that's kind of weird that a two-player game with no dealt cards left is allowed to ping-pong over the lone Sixis card, if both players allow that to happen. But I've confirmed this with the designer.)_

Tapping one of the roll-buttons fires its effect immediately; the dice-rolling animation commences (see below), and any highlighted cards lose their highlights. The buttons themselves also fade away.


### Rolling dice

We will not worry about animating the dice rolling around in a realistic manner.

On tapping one of the "Roll" buttons, the game plays a dice-rattle sound, followed by a dice-landing-on-felt sound as the dice pop into existence on the table, showing the appropriate faces. The dice pop in in a random order (but only split-seconds apart from each other), in a random location (but confined to the player's roll-space), with random rotation.

_Let's consider recording, separately, the sounds of between 1 and 6 dice rattling around. Maybe use a die-cup so that even one die makes a sound, or just be cheeky and let that situation be silent._

After rolling, players can tap a die to lock it. This results in an appropriate sound effect, and a little padlock symbol appears by the die. They can tap it again to clear this; it's a toggle.

When the player ends their turn, all of their lock-marked dice are animated as sweeping into that player's safe. All unlocked dice leave the table in a simple fade-to-zero-opacity animation. These two animations happen at the same time.

When a round ends, every player's locked dice fade from their safes, simultaneously.

## Cards

After every roll, the game highlights every card that the player can claim or flip.

Highlighted cards offer this interactivity:

 * Tap to summon a popover with Buttons
     * Score
     * Flip
         * Unavailable if the card was red at the start of this turn
         * Button reads "Flip back" if the card's red but was blue at the start of this turn
     * Cancel _(Tap outside the popover for the same effect)_
 * Drag to player's own edge to score. (Player's edge highlights on drag or long-tap.)
 * Double-tap to flip _(Unless the card was red at the start of this turn)_
     
Cards that have been flipped _during this turn_ can be flipped back to their blue side, which acts as an effective undo.

__Card Zoom?__ I don't know how legible the cards will be when scaled down enough for a full four-player game. If we can't clearly read all the card text on an iPad 1 or 2, then we'll probably need to offer some kind of card-zoom functionality too. Maybe tap _any_ card once to magnify it on the spot -- perhaps at any time during the game (and therefore by any player). Only one card can be so magnified at a time.

# Music and sound

Let's avoid any sound effects other than "natural" ones: card and dice noises. Finding (or even recording) these should prove trivial.

There will be music, and it will be fabulous space-age bachelor-pad lounge instrumentals that fit the visuals. Think "Girl from Ipanema". I expect that we can find some CC-licensed tunes.

Music needed:

 * Something energetic for the menus
 * Something relaxed for gameplay
 * Something punchy for game-end

## Round / Game end

When a round ends (but the game doesn't end), animate all cards vanishing from the table. Play a card-shuffle noise while "Round _N_" briefly displays itself on the screen. Then re-animate the layout appearing, as per the start of the game.

When the game ends, display a big fat modal with "_Playername_ wins the game!" taking up most of the space. Buttons offer the options "Play again!" and "Return to menu".

# The Tutorial game

_The prototype doesn't need this, but v1.0 certainly does._

The tutorial game is a two-player human-on-bot game using a predefined seed. In this mode alone, non-modal text views will pop up to teach the player how to play. Also in this mode alone, for the first few turns, the player's control will be limited to only those specific moves that the tutorial orders; all other in-game interactivity will be shut off. For example, if the text window concludes an explanation with "Lock the two dice showing a six now," then that's all the player will be able to do.

The script concludes after it's demonstrated every major aspect of the Sixis rules to the player. At this point the player is free to play out the game.