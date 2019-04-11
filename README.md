# oddball
visual oddball test in [Processing](https://processing.org/) for EEG/ERP
measurements (see also [wally](https://github.com/georgezachos/wally)) with OSC
control of [Supercollider](https://supercollider.github.io/) synths

- `make_events.py`: generate `events.csv` for the tests (run this if no events
  file exists)
- `oddball.scd`: OSC responder and synth (run this first)
- `oddball.pde`: oddball file (main)
