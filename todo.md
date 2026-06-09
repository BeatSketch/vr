# TODOs

### Legend

**Must be included**\
Should be included\
*May be included* (if $\exists$ time)

## Renderer
- [ ] *Add some animation for bpm? (what does this mean?) -> Blinking light / lines, etc*
- [ ] *Materials*
- [ ] *More animations*

## UX
- [ ] Grid: tie visibility to a hotkey or menu option (use `render.show_grid`)
- [ ] Show current position in song (i.e. full beats) to user in non.obstructive way (e.g. reduced grid, floor lines only or similar)

## Tracking
- [X] **fix mixed up controllers on some platforms**

## Other
- [ ] Seeking back in the song (when? After completion or in pause menu?)\
    We should do this in both.
    In pause: Send current tracking data for processing and display, user can move around, teleported back to original location on resume
    At end: Essentially the same (see *rerecording*)
- [X] Completion menu -> Buttons to ask user if they want to quit or preview the map
- [ ] Load already existing map
- [ ] *Mac build*
- [ ] *Rerecording*\
    After completion: User can seek to a previous location and record new movements from there
    When pausing, only newly recorded segment sent to processing
- [ ] Customizable button to trigger the pause menu (plus defaults for some platforms?)

## Preview / Seek mode
- [X] Show current time, total time
- [ ] *Show blocks per second at this time (averaged over 5s)*
