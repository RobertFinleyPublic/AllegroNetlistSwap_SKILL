
axlCmdRegister("swapback" `SwapBack_Main_Routine ?cmdType "interactive")

; Pinswap BackAnnotation.  
; Based on Find_DRC.il on Support.Cadence.com
; --  by David J. Scheuring (djs@cadence.com)  Sr. Applications Eng. Cadence Design Systems  Oct. 9, 1995
; Punted over the finish line at the last minute by Robert Finley
; The only data changes this script can make is by an annotate script for Orcad.
;    If it broke something else, I'm sorry I guess.

 (defun SwapBack_Main_Routine ()
  Visible_List=axlVisibleGet()
  Available_Layers=(axlGetParam("paramLayerGroup:DRC Error Class")->groupMembers)
  The_Top_Layer=car(Available_Layers)
  Last_Layer=car(reverse(Available_Layers))
  shell("rm ./RenameScriptHDL.script")
  shell("rm ./RenameScriptOrcad.Script")
  RenameScriptConcept=outfile("./RenameScriptHDL.script" "w")
  RenameScriptCapture=outfile("./RenameScriptOrcad.Script" "w")
  fprintf(RenameScriptCapture "package require capDesignUtil \n \n" )
  List_DRC_Routine()
 ); end defun Find_DRC_Main_Routine

 (defun List_DRC_Routine ()
  axlDBRefreshId(axlDBGetDesign())
  axlClearSelSet()
  List_DRC_From=outfile("List_DRC_From.form" "w")
  fprintf(List_DRC_From "FILE_TYPE=FORM_DEFN VERSION=2\n")
  fprintf(List_DRC_From "FORM\n")
  fprintf(List_DRC_From "FIXED\n")
  fprintf(List_DRC_From "PORT 80 10\n")
  fprintf(List_DRC_From "HEADER \"Generating Annotation Script\"\n")
  fprintf(List_DRC_From "TILE\n")
  fprintf(List_DRC_From "TEXT \"DRC LIST\"\n")
  fprintf(List_DRC_From "TLOC 35 0\n")
  fprintf(List_DRC_From "ENDTEXT\n")
  fprintf(List_DRC_From "FIELD DRC_List\n")
  fprintf(List_DRC_From "FLOC 2 2\n")
  fprintf(List_DRC_From "LIST \"\" 77 6\n")
  fprintf(List_DRC_From "ENDFIELD\n")
  fprintf(List_DRC_From "ENDTILE\n")
  fprintf(List_DRC_From "ENDFORM\n")
  close(List_DRC_From)
  axlFlushDisplay()
  axlShell("redisplay")

  axlSetFindFilter(?enabled '(noall drcs) ?onButtons '(noall drcs))
  DRC_List=axlGetSelSet(axlAddSelectAll())
  axlClearSelSet()
  Error_List=nil

  Error_List=cons(sprintf(dummy "  " ) Error_List)
  (foreach DRC DRC_List
    KeepNetName=nil
    EraseNetName=nil
    viol_list = DRC->violations
    (foreach thisviol viol_list
	thisobjtype=thisviol->objType
	(if thisviol!=nil then
 	  (if thisobjtype == "pin" then 
	    thisnet = thisviol->net->name
	    ValidSuffix=nindex( thisnet '"TEMP" )
	    (if ValidSuffix!=nil then ; if TEMP isn't there, then it's the keeper net?
	       KeepNetName = thisviol->net->name
	     else
	       EraseNetName = thisviol->net->name
            ) ;end if TEMP is prefix
	  ) ; end if pin
	);  if thisviol!= nil
     ) ;  foreach viol
     (if EraseNetName!=nil then
       Error_List=cons(sprintf(dummy "%s net will be renamed to net: %s " KeepNetName EraseNetName) Error_List)
	fprintf(RenameScriptCapture "::capDesignUtil::replaceAlias %s %s \n" KeepNetName EraseNetName)
	fprintf(RenameScriptConcept "_netrename %s %s \n" EraseNetName KeepNetName )
     )
   ) ; for each DRC
  close(RenameScriptCapture)
  close(RenameScriptConcept)
  Error_List=cons(sprintf(dummy "--List of netlist changes to be made to the schematic.  " ) Error_List)

  ; #####################
  ; Display the form/list
  ; #####################
    List_DRC_From=axlFormCreate( (gensym) "List_DRC_From.form" nil nil t)
   (if DRC_List!=nil then
    List_DRC_From=axlFormCreate( (gensym) "List_DRC_From.form" nil nil t)
    (foreach Error Error_List
     axlFormSetField(List_DRC_From "DRC_List" Error)
     axlFormDisplay(List_DRC_From)
    ); end foreach Ref_Des Placed_Lis
   ); end if DRC_List==nil

  shell("rm List_DRC_From.form")
  printf("Schemtic update script is complete.  I guess..\n\n")
  printf(" NOTE:  to update/back annotate the net aliases of a CIS schematic,\n") 
  printf(" Open a CIS Command Window, " ) 
  printf(" TYPE:  source \173\74yourprojectpath\76\134RenameScriptOrcad.Script\175 " ) 

); end defun List_DRC_Routine
