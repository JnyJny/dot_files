# Dot Files 

SRC= bashrc bashpy emacs gitconfig profile pythonrc pyreqs tcshrc

DST= $(SRC:%=${HOME}/.%)

# Macro: LINK filename
#        creates a hard link between $PWD/filename and $HOME/.filename
LINK= ln -f $(PWD)/$(1) $(HOME)/.$(1)

# Macro: COPY filename
#        copies $PWD/filename to $HOME/.filename

COPY= cp --remove-destination $(PWD)/$(1) $(HOME)/.$(1)

.PHONY: help list link copy $(SRC) README.md

all: copy

help:
	@echo "Dot file targets"
	@echo "list - show current status of dot files"
	@echo "link - OVERWRITES EXISTING DOT FILES"

copy: $(SRC)

list: 
	@ls -l $(DST) | awk '{printf("%s\t->\t%s\n",$$9, $$11)}'

$(SRC):
	-@$(call COPY,$@)

clean:
	@rm -rf *~ .*~

