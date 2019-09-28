# Makefile for this project
SYS := $(shell gcc -dumpmachine)
OS = unknown
JOBS = 4

# Detect OS
ifeq ($(SYS),mingw32)
OS = Makefile.windows
INFO = "Windows makefile running..."
endif
ifeq ($(SYS),x86_64-linux-gnu)
OS = Makefile.linux
INFO = "Linux makefile running..."
endif
ifeq ($(SYS),i686-apple-darwin10)
OS = Makefile.osx
INFO = "OSX makefile running..."
endif

# Run the correct OS Makefile (ie: Makefile.windows Makefile.linux)
all:
ifeq ($(OS),unknown)
	@echo "Makefile: Unknown OS, please check your Makefile"
#	@echo $(SYS)
#	@echo $(OS)
else
	@echo $(INFO)
	@echo Compiling...
	@make --no-print-directory -j$(JOBS) -f $(OS)
endif

#
# *** ALL BELOW ARE JUST REDIRECTING TO ITS CURRENT OS PLATFORM ***
#
#
#                    0        1         2         3           4           5
# Project Stages: [empty]->[assets]->[deploy]->[binary]->[installer]->[publish]

# 0: Empty the project ( deletes EVERYTHING in ../Game and ../Temp )
empty:
	@make --no-print-directory -f $(OS) empty

# 1: Recreate the game assets ( deletes EVERYTHING in ../Game/Data and ../Game/User then executes the ../Assets/Makefile )
assets:
	@make --no-print-directory -f $(OS) assets

# 2: Deploys current OS's runtime and other support files ( deploy runtime and everything to run project from ../Game )
deploy:
	@make --no-print-directory -f $(OS) deploy

# 3: Compile binary ( for current OS ) [this is just an alias for "make"]
binary:
	@make --no-print-directory -f $(OS) binary

# 4: Create an installer ( this makes a *typical* installer for current OS )
installer:
	@make --no-print-directory -f $(OS) installer

# 5: Publishes the game ( ftp upload the installer for current OS )
publish:
	@make --no-print-directory -f $(OS) publish

#
# *** Utils for the project ***
#

# Backup the project ( first creates one local backup then ftp uploads the backup to a central backup-server )
backup:
	@make --no-print-directory -f $(OS) backup

# Cleans the project ( deletes everything in ../Temp )
clean:
	@make --no-print-directory -f $(OS) clean

# Log the output to file instead (output.log)
log:
	@echo "Output redirected to file (output.log)"
	@make --no-print-directory -j$(JOBS) -f $(OS) > output.log 2>&1

# Same as [make binary] and execute binary
run:
	@make --no-print-directory -j$(JOBS) -f $(OS) run

# Displays help information for this project ( typically the project stages and utils functions )
help:
	@echo "Displaying help"
	@echo "Stages:    0        1         2         3           4           5"
	@echo "        [empty]->[assets]->[deploy]->[binary]->[installer]->[publish]"
	@echo ""
	@echo "Project Stages:"
	@echo "make empty:     Empty the project (removes everything in ../Game and ../Temp)"
	@echo "make assets:    Recreate the game assets"
	@echo "make deploy:    Deploys current OS's runtime and other support files"
	@echo "make binary:    Compile binary (for current OS) [alias for \"make\"]"
	@echo "make installer: Create an installer (this makes a *typical* installer)"
	@echo "make publish:   Publishes the game (ftp upload the installer for current OS)"
	@echo ""
	@echo "Project Utils:"
	@echo "make backup:    Backup the project (local backup and ftp upload backup)"
	@echo "make clean:     Cleans the project (deletes everything in ../Temp)"
	@echo "make log:       Log the output to file instead (output.log)"
	@echo "make run:       Same as [make binary] and execute binary"
	@echo "make help:      Displays help information for this project"
