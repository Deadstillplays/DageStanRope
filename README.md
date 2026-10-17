# DageStanRope - Danganronpa: Trigger Happy Havoc Asset & Engine Repository

Extracted native assets, high-definition character bustup sprites, authentic backgrounds, sound effects, and parsed LIN scripts from *Danganronpa: Trigger Happy Havoc* for running in Roblox Studio using EditableImage and Luau.

## Structure

- **backgrounds/**: 25 authentic 960x544 environment backgrounds (Classroom 1-A, Dining Hall, Gymnasium, Courtroom, Dorms, Headmaster's Office, School Exterior, etc.).
- **characters/**: High-resolution transparent PNG expressions for all 16 Ultimate Students & Monokuma (Naegi, Sayaka, Kirigiri, Byakuya, Toko, Genocider, Monokuma, Junko, etc.).
- **audio/sfx/**: Original WAV sound effects (Typewriter blips, UI confirm/cancel, Objections, Gavel, Monokuma laugh).
- **scripts/**: Fully parsed JSON event and dialogue scripts from the game's `.lin` bytecode (Prologue entrance monologue, Main hall 15-student meeting, Gymnasium ceremony).
- **manifest.json**: Complete manifest catalog with URLs, dimensions, and metadata.
- **run_server.py**: Local HTTP server for fast local development and testing in Roblox Studio.

## HTTP Access

Assets can be loaded over HTTP via GitHub raw:
```
https://raw.githubusercontent.com/Deadstillplays/DageStanRope/main/manifest.json
https://raw.githubusercontent.com/Deadstillplays/DageStanRope/main/backgrounds/bgd_002.png
https://raw.githubusercontent.com/Deadstillplays/DageStanRope/main/characters/makoto_naegi/makoto_naegi_00.png
```
