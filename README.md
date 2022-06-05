# AllegroNetlistSwap_SKILL
Short skill script that exports a schematic annotation script that renames temporary netlist aliases to create a single net.

This was written for situations including ATE Load/test fixtures or FPGA-based systems where optimizing pin assignments and simplifying the ratsnest pays off.  In general, PCB cost/complexity/performance improves if we are able to assign pins and simplify our ratsnest to minimize the need for vias.   Keeps power planes intact, etc.  This quickly optimizes netlist when we break out nets to headers for lights-out chip verification on the bench.   Keeps a 4-layer stackup without adding SI risk.

This SKILL script is based on an example "Find_DRC.il" on support.cadence.com website.   Written by David J. Scheuring at Cadence in 1995.


PROCESS:
This script uses the SKILL find command to step through any pin-to-pin clearance DRCs.  At the same time, Allegro reports one or more net names of these objects.   We're stealing this feature and adding a protection mechanism.   One of the net name aliases must have a "TEMP" prefix or the DRC is skipped.

You're probably thinking this is dangerous.   But, this script exports a readable annotation script I was able to verify works with Orcad Capture and a second script that is intended to update a Concept HDL design once I figure out how to build an HDL library by myself.  Open the annotation script in a text editor and look for odd assignments.

x Remember:  Pad-to-pad DRC errors are the only thing that causes an entry in the annotation file.
x You could assign pwr/gnd nets to any pin with a TEMP alias if you want.  You will need to cause a DRC error between a pin with a TEMP-prefix net alias and that power pin.

To install:  Copy the skill script "swapback.il" to your %HOME%/pcbenv directory.
In the Allegro command windows, type "skill load swapback.il".   Allegro should respond with a "t".
Type "swapback" to launch the script.   A dialog window should appear.

A window should pop up with a scrolling list of changes found (the pin-to-pin DRC errors with one net having a TEMP prefix, indicating it was written to both kinds of schematic annotation scripts.

To annotate to Orcad Capture CIS, open a command window and type
source {  full path and filename of the RenameScriptOrcad.Script } and press enter.

One problem I have run into is if I have more than 10 or more than 100 temp nets, all temp aliases need to have the same string length or the update will be random.

Hope this helps.

Robert Finley (r_finley@hotmail.com)
