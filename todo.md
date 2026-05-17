# TODOs

### Legend

**Must be included**\
Should be included\
*May be included* (if $\exists$ time)

## Renderer
- [X] Sabers
- [X] Sabers: Rotatable in all directions
- [X] 4 lanes
- [X] Grid
- [ ] Add some animation for bpm? (what does this mean?)
- [ ] *Materials*
- [ ] *More animations*

## UI Library (in VR)
- [X] Buttons
- [ ] Text

## UX
- [ ] Grid: tie visibility to a hotkey or menu option (use `render.show_grid`)
- [ ] Show current position in song (i.e. full beats) to user in non.obstructive way (e.g. reduced grid, floor lines only or similar)

## Audio
- [X] Song loading
- [X] Play / Pause / Seek

## Tracking
- [X] **Grid system**
- [ ] **Match exact Beat Saber grid size** -> I messaged BeatGames, so we can do that once I got a response
- [X] **Show lines for hands** (need to be corrected for saber tips)
- [x] Implement saber tip computation -> pos + dir * len for each state

## Other
- [ ] Seeking back in the song (when? After completion or in pause menu?)\
    We should do this in both.
    In pause: Send current tracking data for processing and display, user can move around, teleported back to original location on resume
    At end: Essentially the same (see *rerecording*)
- [X] Completion menu -> Buttons to ask user if they want to quit or preview the map
- [ ] Load already existing map
- [ ] *Mac build*
- [ ] *Recording*\
    After completion: User can seek to a previous location and record new movements from there
    When pausing, only newly recorded segment sent to processing

## Preview / Seek mode
- [ ] **Move in time using joysticks**
- [ ] Show current time, total time
- [ ] *Show blocks per second at this time (averaged over 5s)*
