# Color Clutter

This is a simple game, **Color Clutter**, made in [Godot 2.1.3][godot], created as a
demo to show off the *Speech to Text* module.

## Requirement

You will need a microphone connected to your system. If more than one is connected,
**Color Clutter** will use the microphone configured as default.

## Rules

### Objective

When the game is started, the user must say **"start"** to begin. The screen will
change to a colored background, with a colored word appearing on screen. The
objective is to correctly say the color that corresponds to what the upper left
corner word says, which will change the current screen. Try to score as many right
answers as possible!

### HUD

HUD elements include:

- **Time left** (upper right corner): Time remaining until the game's end.

- **Score** (upper right corner, below *time left*): Number of correct answers.

- **Objective** (upper left corner): What must be said by the user. It can be one of
the following:

    - *Text:* The word itself that appears on screen.

    - *Fill:* Color of the word that appears on screen.

    - *Background:* Background color.

### Commands

The game is entirely controlled through English speech, with the answer to each
screen always being one of the following colors:

- Red
- Green
- Blue
- Yellow
- Purple
- Orange
- White

Two other voice commands exist:

- **Start:** Starts the game.
- **Exit:** Ends the game.

## Assets

The below assets were used in this game:

- **Speech to text**
  - Model and dictionary files are from [Pocketsphinx 5prealpha][pocketsphinx]

- **Fonts**
  - [Nunito][nunito] as the main font
  - [Ticking Time Bomb][tickingTimeBomb] for the clock font

- **Sounds**
  - [Tone beep][toneBeep] as the "correct answer" sound effect
  - [Game start][gameStart] as the "say start" sound effect

- **Icon**
  - [Gooey molecule][gooeyMolecule] as the game icon

[godot]: https://godotengine.org "Godot site"
[pocketsphinx]: https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/
[nunito]: https://fonts.google.com/specimen/Nunito
[tickingTimeBomb]: https://www.1001freefonts.com/ticking_time_bomb.font
[toneBeep]: https://freesound.org/people/pan14/sounds/263133/
[gameStart]: https://freesound.org/people/plasterbrain/sounds/243020/
[gooeyMolecule]: http://game-icons.net/lorc/originals/gooey-molecule.html
