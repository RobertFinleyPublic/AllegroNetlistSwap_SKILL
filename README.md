# AllegroNetlistSwap_SKILL
Short skill script that exports a schematic annotation script that renames temporary netlist aliases to create a single net.

This was written for situations including ATE Load/test fixtures or FPGA-based systems where optimizing pin assignments and simplifying the ratsnest pays off.  In general, PCB cost/complexity/performance improves if we are able to assign pins and simplify our ratsnest to minimize the need for vias.   Keeps power planes intact, etc.  This quickly optimizes netlist when we break out nets to headers for lights-out chip verification on the bench.   Keeps a 4-layer stackup without adding SI risk.

This SKILL script is based on an example "Find_DRC.il" on support.cadence.com website.   Written by David J. Scheuring at Cadence in 1995.


PROCESS:
This script uses the SKILL find command to step through pin-to-pin clearance DRCs.  Allegro includes net names of the DRC objects.   We're stealing this feature and adding a protection mechanism:  One of the net name aliases must have a "TEMP" prefix or the DRC is skipped.

This script exports an annotation script to be imported to Orcad Capture.  There is also a second script intended to update a Concept HDL design.   I have not had the opportunity to verify its syntax as I don't use HDL.  Open the annotation script in a text editor and look for odd assignments before importing it to your schematic.

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
