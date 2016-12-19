# The Sixis Philosophy of Objects

Each Sixis game involves an instance of a SixisGame object. This is a pure business-logic Objective C class able to completely represent a Sixis game's state, at any given point, whether between turns, mid-turn, before the game has started or after it ends. It has a suite of methods and public properties that other entities can query to learn about the game. It contains player, card, and dice objects, as appropriate.

The game table is lorded over by a single view controller (SixisTableViewController). This controller is the sole delegate of all touch events that happen during gameplay. Tapping different objects will fire different methods in the controller. Each of these methods is  smart enough to guide the player through whatever steps are necessary before the game state must actually change. (e.g. The player taps a card, taps "Never mind", taps another card, then taps "Take".) Eventually, the controller tells the game instance it's holding about a state change (e.g. the player has taken a card), and it updates its display appropriately (e.g. it animates the player's score increasing).

As much as possible, the controller lets the game object handle the logic. For example,  after a dice roll, the controller does not decide which cards to highlight. Instead, it queries the game object about which cards the player is now qualified to interact with. If there are any, it adjusts those cards' views as appropriate.

Cards and dice are just custom UIViews. They know how to draw themselves given a handful of obvious public properties. e.g. SixisCardView contains @property SixisCard *card. 

## The flow of a sixis game

The controller sets up its initial views. It knows how many players there are and whether there are teams, and responds appropriately. Every space where a card might sit is an instance of SixisCardView; when it has no card assigned to it, it's transparent.

The controller sends the game (which was instantiated during the game-configuration interaction) a startGame message. 

### ROUND BEGIN.

The controller asks the game if anybody has won (due to someone winning enough rounds). If so, the controller announces the fact, and displays appropriate game-over controls. GAME OVER.

The controller asks the game for the array of cards on the table. It then assigns each card to one of its child SixisCardViews, marking them for redraw. These views' drawRect: methods see what cards they hold, and display the appropriate image at the appropriate scale and rotation.

### TURN BEGIN.

The game checks to see if anyone has won (due to someone winning enough points). If not, it checks to see if the round has ended. If so, it raises a flag that a new round is starting, and sets up a new tableful of cards. 

The controller asks the game if anybody has won. If so, the controller announces the fact, and displays appropriate game-over controls. GAME OVER.

Unless the controller already knows that a new round has begun, the controller asks the game if a new round has begun. If so, go to ROUND BEGIN.

The controller asks the game whose turn it is, and how many locked dice they have. It presents that player with either a "Roll!" button or a pair of "Roll all dice" and "Roll only unlocked dice" buttons.

The controller tells the game object what the player did with their dice.

The controller asks the game object what the roll result was, and which cards the player may now interact with.

The controller animates the dice falling on the table, then animates the player's locked dice (if any) moving from their safe onto the table. The controller then highlights all the cards that the player is qualified to take or flip. These dice and cards now listen for tap events, as does an "End Turn" button that appears.

Tapping a rolled die toggles it between unlocked and locked (the latter represented with a little padlock symbol). This can happen as much as a player pleases. Dice that the player just rolled begin without a lock symbol attached, while dice that moved out of a player's safe begin with the lock symbol -- that is, they'll just go right back into the safe by default.

Tapping a highlighted blue card displays a pop-up menu: Take (Green button), Flip (Blue button), Never Mind (Red button).

Tapping a highlighted red card is the same, but without a Flip button.

Tapping "Take" will have the controller tell the game that this happened, then ask the game what the user's score is. The controller animates the user's score increasing, and removes the card from the board.

Tapping "Flip" will have the controller tell the game that this happened, then ask the game what card is in that spot. It replaces the view's card appropriately.

Tapping "End Turn" will have the controller tell the game which dice the player chose to lock. The controller animates the dice moving to the player's safe, and removes the other dice from the board.

Go to TURN BEGIN.

## Saving a game

The game object just recursively archives itself using NSCoder.

## Restoring a game

The controller asks the game object about:

 * The current card array
 * Each player's locked dice
 * Whose turn it is
 * Whether this player has rolled yet
 * What dice they have rolled
 * Whether this player has already taken or flipped a card this turn
 * What cards this player can take
 
It then updates the board appropriately.