# ----------------------------------------
# Makefile for mo
# Generated using ontology-starter-kit
# ODK Version: v1.2.17
# ----------------------------------------
# <do not edit above this line>

# ----------------------------------------
# Standard Constants
# ----------------------------------------
# these can be overwritten on the command line

URIBASE=                    http://purl.obolibrary.org/obo
ONT=                        mo
ONTBASE=                    $(URIBASE)/$(ONT)
EDIT_FORMAT=                owl
SRC =                       $(ONT)-edit.$(EDIT_FORMAT)
CATALOG=                    catalog-v001.xml
ROBOT=                      robot --catalog $(CATALOG)
RELEASEDIR=                 ../..
PATTERNDIR=                 ../patterns
REPORTDIR=                 reports
SPARQLDIR =                 ../sparql
REPORT_FAIL_ON =            none
OBO_FORMAT_OPTIONS =        
SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference xref-syntax nolabels
SPARQL_EXPORTS =            basic-report class-count-by-prefix edges xrefs obsoletes synonyms
ODK_VERSION =               v1.2.17

TODAY ?= $(shell date +%Y-%m-%d)
OBODATE ?= $(shell date +'%d:%m:%Y %H:%M')


FORMATS = $(sort  owl obo json owl)
FORMATS_INCL_TSV = $(sort $(FORMAT) tsv)
RELEASE_ARTEFACTS = $(sort  base full non-classified base full)

# ----------------------------------------
# Top-level targets
# ----------------------------------------

.PHONY: .FORCE
all: odkversion all_imports all_main all_subsets sparql_test all_reports all_assets
test: odkversion sparql_test all_reports
	$(ROBOT) reason --input $(SRC) --reasoner ELK  --equivalent-classes-allowed all --output test.owl && rm test.owl && echo "Success"

odkversion:
	echo "ODK Makefile version: $(ODK_VERSION) (this is the version of the ODK with which this Makefile was generated, not the version of the ODK you are running)" &&\
	echo "ROBOT version (ODK): " && $(ROBOT) --version

## -- main targets --
##
## By default this is the cross-product of {ont, ont-base} x FORMATS

MAIN_PRODUCTS = $(sort $(foreach r,$(RELEASE_ARTEFACTS), $(ONT)-$(r)) $(ONT))
MAIN_GZIPPED = 
MAIN_FILES = $(foreach n,$(MAIN_PRODUCTS), $(foreach f,$(FORMATS), $(n).$(f))) $(MAIN_GZIPPED)

all_main: $(MAIN_FILES)

## -- import targets --
##
## By default this is the cross-product of IMPORT_MODULES x FORMATS


IMPORTS =  nbo go uberon ro chebi hsapdv cl mpath ncbitaxon-taxslim.owl go-plus so eco uberon-ext uberon-bridge-to-zfa.owl uberon/bridge/uberon-bridge-to-ma.owl uberon/bridge/uberon-bridge-to-fma.owl uberon/bridge/cl-bridge-to-zfa.owl uberon/bridge/cl-bridge-to-ma.owl uberon/bridge/cl-bridge-to-fma.owl uberon/bridge/uberon-bridge-to-nifstd.owl pato

IMPORT_ROOTS = $(patsubst %, imports/%_import, $(IMPORTS))
IMPORT_FILES = $(foreach n,$(IMPORT_ROOTS), $(foreach f,$(FORMATS), $(n).$(f)))
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)

all_imports: $(IMPORT_FILES)

all_imports_owl: $(foreach n,$(IMPORT_ROOTS), $(n).owl)

all_imports_obo: $(foreach n,$(IMPORT_ROOTS), $(n).obo)

all_imports_json: $(foreach n,$(IMPORT_ROOTS), $(n).json)


## -- subset targets --
##
## By default this is the cross-product of SUBSETS x FORMATS
## Note we also include TSV as a format


SUBSETS = 

SUBSET_ROOTS = $(patsubst %, subsets/%, $(SUBSETS))
SUBSET_FILES = $(foreach n,$(SUBSET_ROOTS), $(foreach f,$(FORMATS_INCL_TSV), $(n).$(f)))

all_subsets: $(SUBSET_FILES)

## -- dosdp pattern targets --
##


PATTERNS = 

PATTERN_ROOTS = $(patsubst %, $(PATTERNDIR)/%, $(PATTERNS))
PATTERN_FILES = $(foreach n,$(PATTERN_ROOTS), $(n).owl)

all_patterns: $(PATTERN_FILES)

## -- dosdp pattern targets --
##

OBO_REPORT = $(SRC)-obo-report
REPORTS = $(OBO_REPORT)
REPORT_FILES = $(patsubst %, $(REPORTDIR)/%.tsv, $(REPORTS))

all_reports: all_reports_onestep $(REPORT_FILES)

## -- all files/assets --

ASSETS = \
  $(IMPORT_FILES) \
  $(MAIN_FILES) \
  $(REPORT_FILES) \
  $(SUBSET_FILES)

all_assets: $(ASSETS)

show_assets:
	echo $(ASSETS)
	du -sh $(ASSETS)


# ----------------------------------------
# Release Management
# ----------------------------------------

KEEPRELATIONS=keeprelations.txt
ONTOLOGYTERMS=ontologyterms.txt
SIMPLESEED=simple_seed.txt

# This should be executed by the release manager whenever time comes to make a release.
# It will ensure that all assets/files are fresh, and will copy to release folder
prepare_release: $(ASSETS) $(PATTERN_RELEASE_FILES)
	rsync -R $(ASSETS) $(RELEASEDIR) &&\
  echo "Release files are now in $(RELEASEDIR) - now you should commit, push and make a release on your git hosting site such as GitHub or GitLab"

prepare_initial_release: prepare_release
	cd $(RELEASEDIR) && git add $(ASSETS)

# ----------------------------------------
# Export formats
# ----------------------------------------


$(ONT)-base.obo: $(ONT)-base.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT)-base.json: $(ONT)-base.owl
	$(ROBOT) annotate --input $< --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
$(ONT)-full.obo: $(ONT)-full.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT)-full.json: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
$(ONT)-non-classified.obo: $(ONT)-non-classified.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT)-non-classified.json: $(ONT)-non-classified.owl
	$(ROBOT) annotate --input $< --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
# Main release artefacts
$(ONT).owl: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

$(ONT).obo: $(ONT).owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT).json: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY) \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
# ----------------------------------------
# Initiating Step: Reason over source
# ----------------------------------------

ANNOTATE_VERSION_IRI = annotate -V $(ONTBASE)/releases/$(TODAY)/$@.owl

# by default we use ELK to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo

OTHER_SRC =   components/upheno.owl components/mondo.owl components/eco.owl components/so.owl


$(ONTOLOGYTERMS): $(SRC) $(OTHER_SRC)
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/mo_terms.sparql $@











# base: OTHER sources of interest, such as definitions owl
$(ONT)-base.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) remove --input $< --select imports --trim false \
		merge $(patsubst %, -i %, $(OTHER_SRC)) \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

# Full: The full artefacts with imports merged, reasoned
$(ONT)-full.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

# foo-non-classified: (edit->imports-merged)
$(ONT)-non-classified.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@
# ----------------------------------------
# Import modules
# ----------------------------------------
# Most ontologies are modularly constructed using portions of other ontologies
# These live in the imports/ folder

# seed.txt contains all referenced entities


seed.txt: $(SRC)
	@if [ $(IMP) = true ]; then $(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/terms.sparql $@; fi


# Generate terms.txt for each import.  (Assume OBO-style Possibly hacky step?)
# Should be able to drop this if robot can just take a big messy list of terms as input.

imports/%_terms_combined.txt: seed.txt imports/%_terms.txt
	@if [ $(IMP) = true ]; then cat $^ | grep -v ^# | sort | uniq >  $@; fi

# -- Generate Import Modules --
#
# This pattern uses ROBOT to generate an import module
imports/%_import.owl: mirror/%.owl imports/%_terms_combined.txt
	@if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/$*_terms_combined.txt --force true --method BOT \
		query --update ../sparql/inject-subset-declaration.ru \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@; fi
.PRECIOUS: imports/%_import.owl

# convert imports to obo.
# this can be useful for spot-checks and diffs.
# we set strict mode to false by default. For discussion see https://github.com/owlcs/owlapi/issues/752
imports/%_import.obo: imports/%_import.owl
	@if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f obo -o $@.tmp.obo && mv $@.tmp.obo $@; fi
imports/%_import.json: imports/%_import.owl
	@if [ $(IMP) = true ]; then $(ROBOT) convert --check false -i $< -f json -o $@.tmp.json && mv $@.tmp.json $@; fi
# ----------------------------------------
# Mirroring upstream ontologies
# ----------------------------------------
#

IMP=true # Global parameter to bypass import generation
MIR=true # Global parameter to bypass mirror generation



## ONTOLOGY: nbo
## Copy of nbo is re-downloaded whenever source changes
mirror/nbo.trigger: $(SRC)

mirror/nbo.owl: mirror/nbo.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/nbo/nbo-base.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: go
## Copy of go is re-downloaded whenever source changes
mirror/go.trigger: $(SRC)

mirror/go.owl: mirror/go.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/go.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon
## Copy of uberon is re-downloaded whenever source changes
mirror/uberon.trigger: $(SRC)

mirror/uberon.owl: mirror/uberon.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/uberon.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: ro
## Copy of ro is re-downloaded whenever source changes
mirror/ro.trigger: $(SRC)

mirror/ro.owl: mirror/ro.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/ro.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: chebi
## Copy of chebi is re-downloaded whenever source changes
mirror/chebi.trigger: $(SRC)

mirror/chebi.owl: mirror/chebi.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/chebi.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: hsapdv
## Copy of hsapdv is re-downloaded whenever source changes
mirror/hsapdv.trigger: $(SRC)

mirror/hsapdv.owl: mirror/hsapdv.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/hsapdv.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl
## Copy of cl is re-downloaded whenever source changes
mirror/cl.trigger: $(SRC)

mirror/cl.owl: mirror/cl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/cl/cl-base.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: mpath
## Copy of mpath is re-downloaded whenever source changes
mirror/mpath.trigger: $(SRC)

mirror/mpath.owl: mirror/mpath.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/mpath.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: ncbitaxon-taxslim.owl
## Copy of ncbitaxon-taxslim.owl is re-downloaded whenever source changes
mirror/ncbitaxon-taxslim.owl.trigger: $(SRC)

mirror/ncbitaxon-taxslim.owl.owl: mirror/ncbitaxon-taxslim.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/ncbitaxon/subsets/taxslim.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: go-plus
## Copy of go-plus is re-downloaded whenever source changes
mirror/go-plus.trigger: $(SRC)

mirror/go-plus.owl: mirror/go-plus.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/go/extensions/go-plus.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: so
## Copy of so is re-downloaded whenever source changes
mirror/so.trigger: $(SRC)

mirror/so.owl: mirror/so.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/so.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: eco
## Copy of eco is re-downloaded whenever source changes
mirror/eco.trigger: $(SRC)

mirror/eco.owl: mirror/eco.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/eco.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-ext
## Copy of uberon-ext is re-downloaded whenever source changes
mirror/uberon-ext.trigger: $(SRC)

mirror/uberon-ext.owl: mirror/uberon-ext.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/ext.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-zfa.owl
## Copy of uberon-bridge-to-zfa.owl is re-downloaded whenever source changes
mirror/uberon-bridge-to-zfa.owl.trigger: $(SRC)

mirror/uberon-bridge-to-zfa.owl.owl: mirror/uberon-bridge-to-zfa.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-zfa.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/uberon-bridge-to-ma.owl
## Copy of uberon/bridge/uberon-bridge-to-ma.owl is re-downloaded whenever source changes
mirror/uberon/bridge/uberon-bridge-to-ma.owl.trigger: $(SRC)

mirror/uberon/bridge/uberon-bridge-to-ma.owl.owl: mirror/uberon/bridge/uberon-bridge-to-ma.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-ma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/uberon-bridge-to-fma.owl
## Copy of uberon/bridge/uberon-bridge-to-fma.owl is re-downloaded whenever source changes
mirror/uberon/bridge/uberon-bridge-to-fma.owl.trigger: $(SRC)

mirror/uberon/bridge/uberon-bridge-to-fma.owl.owl: mirror/uberon/bridge/uberon-bridge-to-fma.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-fma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/cl-bridge-to-zfa.owl
## Copy of uberon/bridge/cl-bridge-to-zfa.owl is re-downloaded whenever source changes
mirror/uberon/bridge/cl-bridge-to-zfa.owl.trigger: $(SRC)

mirror/uberon/bridge/cl-bridge-to-zfa.owl.owl: mirror/uberon/bridge/cl-bridge-to-zfa.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-zfa.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/cl-bridge-to-ma.owl
## Copy of uberon/bridge/cl-bridge-to-ma.owl is re-downloaded whenever source changes
mirror/uberon/bridge/cl-bridge-to-ma.owl.trigger: $(SRC)

mirror/uberon/bridge/cl-bridge-to-ma.owl.owl: mirror/uberon/bridge/cl-bridge-to-ma.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-ma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/cl-bridge-to-fma.owl
## Copy of uberon/bridge/cl-bridge-to-fma.owl is re-downloaded whenever source changes
mirror/uberon/bridge/cl-bridge-to-fma.owl.trigger: $(SRC)

mirror/uberon/bridge/cl-bridge-to-fma.owl.owl: mirror/uberon/bridge/cl-bridge-to-fma.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-fma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon/bridge/uberon-bridge-to-nifstd.owl
## Copy of uberon/bridge/uberon-bridge-to-nifstd.owl is re-downloaded whenever source changes
mirror/uberon/bridge/uberon-bridge-to-nifstd.owl.trigger: $(SRC)

mirror/uberon/bridge/uberon-bridge-to-nifstd.owl.owl: mirror/uberon/bridge/uberon-bridge-to-nifstd.owl.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-nifstd.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: pato
## Copy of pato is re-downloaded whenever source changes
mirror/pato.trigger: $(SRC)

mirror/pato.owl: mirror/pato.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/pato.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl



# ----------------------------------------
# Subsets
# ----------------------------------------
subsets/%.tsv: subsets/%.owl
	$(ROBOT) query -f tsv -i $< -s ../sparql/labels.sparql $@
subsets/%.owl: $(ONT).owl
	owltools --use-catalog $< --extract-ontology-subset --fill-gaps --subset $* -o $@.tmp.owl && mv $@.tmp.owl $@


# ----------------------------------------
# Release
# ----------------------------------------
# copy from staging area (this directory) to top-level
release: $(ONT).owl $(ONT).obo
	cp $^ $(RELEASEDIR) && cp imports/* $(RELEASEDIR)/imports

# ----------------------------------------
# Sparql queries: Q/C
# ----------------------------------------

# these live in the ../sparql directory, and have suffix -violation.sparql
# adding the name here will make the violation check live.
# NOTE: these will soon be phased out and replaced by robot-report

#  run all violation checks
SPARQL_VALIDATION_QUERIES = $(foreach V,$(SPARQL_VALIDATION_CHECKS),$(SPARQLDIR)/$V-violation.sparql)
sparql_test: $(SRC)
	$(ROBOT) verify  --catalog catalog-v001.xml -i $< --queries $(SPARQL_VALIDATION_QUERIES) -O reports/

# ----------------------------------------
# ROBOT report
# ----------------------------------------
reports/%-obo-report.tsv: %
	$(ROBOT) report -i $< --fail-on $(REPORT_FAIL_ON) -o $@

# ----------------------------------------
# Sparql queries: Exports
# ----------------------------------------

SPARQL_EXPORTS_ARGS = $(foreach V,$(SPARQL_EXPORTS),-s $(SPARQLDIR)/$V.sparql reports/$V.tsv)
# This combines all into one single command
all_reports_onestep: $(SRC)
	$(ROBOT) query -f tsv -i $< $(SPARQL_EXPORTS_ARGS)


# ----------------------------------------
# Docker (experimental)
# ----------------------------------------
IM=build-$(ONT)
build-docker:
	docker build -t $(ONT) .









include mo.Makefile