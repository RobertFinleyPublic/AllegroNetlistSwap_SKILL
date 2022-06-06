# AllegroNetlistSwap_SKILL
Short skill script that parses pad-to-pad DRC errors in Allegro and writes an annotation script for the schematic renaming temporary netlist aliases to merge to an existing net.

This was written for situations including ATE Load/test fixtures or FPGA-based systems where optimizing pin assignments and simplifying the ratsnest pays off.  
I use this to add test headers to a verification board (connecting test equipment) for automated bench verification using our customer demo board.

This SKILL script is based on an example "Find_DRC.il" on support.cadence.com website.   Written by David J. Scheuring at Cadence in 1995.

-----

PROCESS:
This script uses the SKILL find command to step through pin-to-pin clearance DRCs.  Allegro includes net names of the DRC objects.   We're stealing this feature and adding a protection mechanism:  One of the net name aliases must have a "TEMP" prefix or the DRC is skipped.

For each net name in your existing, add a small test pad to each net.   The destination will be a (FPGA or connector) pin, defined as a single-pin-net with a "TEMP" name alias prefix.   TEMP1000, TEMP10001, TEMP1002, as example as all of these aliases must have the same length.

The test pad should be small enough to fit near the destination pin and cause a DRC with the intended pin, not adjacent pins.  If multiple DRC errors happen on a destination pin, the resulting annotation to convert the TEMP alias to a final name will be unpredictible.  

After you have completed the assignment process, remove the testpads from your schematic and re-sync the design to remove them from the board.  There should be a clean netlist in layout.

This script exports an annotation script to be imported to Orcad Capture with a second script intended to update a Concept HDL design.   I don't use HDL and have not had the opportunity to verify its syntax.  

View the annotation script in a text editor and look for odd assignments before importing it to your schematic.

---------------------
To install:  Copy the skill script "swapback.il" to your %HOME%/pcbenv directory.
In the Allegro command windows, type "skill load swapback.il".   Allegro should respond with a "t".
Type "swapback" to launch the script.   A dialog window should appear.

Swapback launches an interactive window with a scrolling list of results (the pin-to-pin DRC errors with one net having a TEMP prefix, indicating it was exported.)

To annotate to Orcad Capture CIS, open a command window and type
      source {  full path and filename of the RenameScriptOrcad.Script } and press enter.

One problem:  All temp aliases need to have the same string length or the schemaitc update will be random.  Start with TEMP100 or TEMP1000 in your net alias.

Hope this saves you time and drives a better design.

Robert Finley (r_finley@hotmail.com)
