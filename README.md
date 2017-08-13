## TES Patcher ##

A simple tool written in ruby, to patch TES encoded RPG Maker VX ACE files.

### Usage Guide ###
1. Extract the game data e.g. by using RPG Maker All Decrypter (please refere to one of the  
many guides on how to apply RPG Maker patches for a more detailed explanation e.g. [here](http://www.ulmf.org/bbs/showthread.php?t=28259)).

2. Copy TES_Patcher.exe into the game base directory (the directory containing Game.exe and the Data folder;  
see picture below).  
![](http://i.imgur.com/QnLAtI7.png)
3. Open a command line in the folder and run:  
`TES_Patcher -e`  
This will extract the encrypted dialogs and save them into several different text files inside the folder "extract_main".  
The used patching file format is similar to the one from RPGMakerTrans e.g. just insert your translation in the blank  
section between `> VALUE ID:` and `> END STRING` and as with RPGMakerTrans don't touch any of the other stuff, it  
might break something during the patching process.

4. Once the translation is done run:  
`TES_Patcher -p`  
to start the patching process. When the patching is done the patched main.rvdata2 will be created in the game base  
directory, just copy it into the folder containing the original main.rvdata2 (default: Data) file (make sure to create  
a backup of the original main.rvdata2 file just in case something went wrong). Once the patched file is copied the  
translated dialogs should show up in the game.  
  
#### Note ####
In case the main.rvdata2 is not inside the data folder the `-m` switch can be used to specify a different directory.  
In the example picture above main is located inside *Arc* therefore the TES Patcher has to be called with `-m Arc`.

#### Important information ####
The extraction is not incremental, every rerun will override existing files therefore it is recommended to backup existing  
work before rerunning the extraction.


----------


### Parameter ###
    TES_Patcher function [options]

**Help:**

    -h, --help                       Displays Help

**Main Functions:**

    -e, --extract [dir]              Extracts the event texts from the encoded
                                     main.rvdata2 to "dir". If "dir" is not set
                                     the default output dir is "extract_main".

    -p, --patch [dir]                Patches main.rvdata2 using the files from
                                     "dir". If "dir" is not set the default
                                     input dir is "extract_main".
                                     The patched file will be stored in the
                                     current directory as:
                                     main.rvdata2`

**Options:**

    -a, --add_code code              Add additional event codes for the
                                     extraction process.
                                     Default used codes: 401, 408

    -m, --main_dir dir               Changes the search location of
                                     main.rvdata2 to "dir".

**Debug Functions:**

    -d, --dump_script                Dump all scripts inside Scripts.rvdata2
                                     into separate files.

    -D, --dump_main                  Create a full dump of main.rvdata2.

    -c, --event_codes                Prints a list of all event codes used
                                     inside main.rvdata2.

### Event Codes (-a, --add_code) ###

By default only the events 401 (Show Text - Text Data) and 408 (Choice Item) are extracted.  
In most cases this is enough to cover all visible text, but in some cases certain options or  
progress texts are stored inside custom events, in order to translate these the option `-a` has  
to be used during the extraction process together with the event code for which the data should  
be extracted e.g. `-a reflesh_history`. Multiple event codes can be specified via comma e.g.  
`-a reflesh_history,npch_end`. **Important: NO spaces in between**

Using the option `-c` a list of all event codes used in this game will be printed.  
A simple way to find the event code associated with a specific text is to dump the entire content  
using the option `-D` and then search for the text, which will be listed as the parameter of the event.  
The block surrounding the text will look like this:

	EventCode: reflesh_history  
	Indent: 1  
	Parameter count: 4  
	Parameters:  
	....

The *EventCode* is the required event code for this kind of text.


### Examples ###

Extract the default event texts while *main.rvdata2* is located inside the data folder:  
`TES_Patcher -e`

Extract the default event texts while *main.rvdata2* is located inside the folder *Arc*:  
`TES_Patcher -m Arc -e`

Extract the default events as well as the events reflesh_history and npch_end while *main.rvdata2* is located inside the data folder:  
`TES_Patcher -e -a reflesh_history,npch_end`

Patch *main.rvdata2* while it is located inside the data folder:  
`TES_Patcher -p`

Patch *main.rvdata2* while it is located inside the folder *Arc*:  
`TES_Patcher -m Arc -p`

**Note:** The patching process does not care about the event codes, it just patches everything it can find so `-a` is not required.
