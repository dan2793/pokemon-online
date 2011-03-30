# Default qmake binary. Some systems have qmake-qt4 and qmake-qt3 instead.
QMAKE=qmake
# Default make binary. Some systems have nmake or gmake (some bsds)
MAKE=make

install-message="Nothing to do, run the executable in the bin folder and make sure to edit your ~/.bashrc to add the path to the bin directory to LD_LIBRARY_PATH"

all: client server plugins
	@echo "Read instructions in HowToBuild.txt"
	@echo ${install-message}

%.cpp: ;
%.o: ;
%.h: ;
DIRE = src/Utilities src/Teambuilder src/Server src/PokemonInfo			\
src/BattleLogs src/veekun_data_extracter src/ChainBreeding src/MoveMachine	\
src/EventCombinations src/level_balance src/UsageStatistics			\
src/StatsExtracter src/Registry src/DOSTest src/PokesIndexConverter

# Instruct make on how to convert any given .pro file to a Makefile
# and then compile that Makefile. This expands to the correct rule for
# whichever directory needs making.
define QMAKE_template
 $(1)/%.pro: Makefile $$(wildcard $(1)/*.cpp) $$(wildcard $(1)/*.h) $$(wildcard $(1)/*.o)
	$$(QMAKE) -makefile -o ${1}/Makefile $$@
	$${MAKE} -C $${@D}
endef

$(foreach d, ${DIRE}, $(eval $(call QMAKE_template,$(d))))

utilities: src/Utilities/Utilities.pro ;

pokemon-info: utilities src/PokemonInfo/PokemonInfo.pro ;

battlelogs: pokemon-info src/BattleLogs/BattleLogs.pro ;
usagestats: pokemon-info src/UsageStatistics/UsageStatistics.pro ;
plugins: battlelogs usagestats ;

client: pokemon-info src/Teambuilder/Teambuilder.pro ;

server:	pokemon-info src/Server/Server.pro ;

install:
	@echo ${install-message}

# This should also clean up any binaries generated, but
# we can mess with these later.
clean:
	${RM} src/*/*.o 		# Remove all object files
	${RM} src/Teambuilder/Makefile	# Remove generated makefiles
	${RM} src/Server/Makefile
	${RM} src/Utilities/Makefile
	${RM} src/PokemonInfo/Makefile
