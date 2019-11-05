# ----------------------------------------
# Makefile for mo
# Generated using ontology-starter-kit
# ODK Version: v1.2.19
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
REPORTDIR=                  reports
TMPDIR=                     tmp
SPARQLDIR =                 ../sparql
REPORT_FAIL_ON =            none
OBO_FORMAT_OPTIONS =        
SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference xref-syntax nolabels
SPARQL_EXPORTS =            basic-report class-count-by-prefix edges xrefs obsoletes synonyms
ODK_VERSION =               v1.2.19

TODAY ?= $(shell date +%Y-%m-%d)
OBODATE ?= $(shell date +'%d:%m:%Y %H:%M')


FORMATS = $(sort  owl owl)
FORMATS_INCL_TSV = $(sort $(FORMAT) tsv)
RELEASE_ARTEFACTS = $(sort  base full non-classified base full)

# ----------------------------------------
# Top-level targets
# ----------------------------------------

.PHONY: .FORCE
all: odkversion all_imports all_main all_subsets sparql_test all_reports all_assets
test: odkversion sparql_test all_reports
	$(ROBOT) reason --input $(SRC) --reasoner ELK  --equivalent-classes-allowed all --exclude-tautologies structural --output test.owl && rm test.owl && echo "Success"

odkversion:
	echo "ODK Makefile version: $(ODK_VERSION) (this is the version of the ODK with which this Makefile was generated, not the version of the ODK you are running)" &&\
	echo "ROBOT version (ODK): " && $(ROBOT) --version

$TMPDIR:
	mkdir -p $@

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


IMPORTS =  nbo fao oba po vt stato bfo hsapdv cl mpath ncbitaxon-taxslim caro uberon-ext uberon-bridge-to-zfa uberon-bridge-to-ma uberon-bridge-to-wbbt uberon-bridge-to-fbbt uberon-bridge-to-fma uberon-bridge-to-nifstd cl-bridge-to-ma cl-bridge-to-fma cl-bridge-to-wbbt cl-bridge-to-fbbt cl-bridge-to-zfa

IMPORT_ROOTS = $(patsubst %, imports/%_import, $(IMPORTS))
IMPORT_FILES = $(foreach n,$(IMPORT_ROOTS), $(foreach f,$(FORMATS), $(n).$(f)))
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)

all_imports: $(IMPORT_FILES)

all_imports_owl: $(foreach n,$(IMPORT_ROOTS), $(n).owl)


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


# Main release artefacts
$(ONT).owl: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

# ----------------------------------------
# Initiating Step: Reason over source
# ----------------------------------------

ANNOTATE_VERSION_IRI = annotate -V $(ONTBASE)/releases/$(TODAY)/$@.owl

# by default we use ELK to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo

OTHER_SRC =   components/pato.owl components/go.owl components/go-plus.owl components/upheno.owl components/mondo.owl components/eco.owl components/so.owl components/geno.owl components/sepio.owl components/ro.owl components/clo.owl components/uberon.owl components/ncit.owl components/fbbt.owl components/wbbt.owl components/ecto.owl components/zfa.owl components/maxo.owl components/chebi.owl


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
		reason --reasoner ELK --equivalent-classes-allowed all --exclude-tautologies structural \
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


# ----------------------------------------
# Components
# ----------------------------------------
# Some ontologies contain external and internal components. A component is included in the ontology in its entirety.

components/%: .FORCE
	touch $@
.PRECIOUS: components/%




components/pato.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/pato/pato-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/pato.owl



components/go.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://current.geneontology.org/ontology/go-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/go.owl



components/go-plus.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/go/extensions/go-plus.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/go-plus.owl



components/upheno.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I https://raw.githubusercontent.com/obophenotype/upheno/master/metazoa.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/upheno.owl



components/mondo.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/mondo/mondo-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/mondo.owl



components/eco.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/eco/eco-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/eco.owl



components/so.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/so.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/so.owl



components/geno.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/geno.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/geno.owl



components/sepio.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/sepio.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/sepio.owl



components/ro.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/ro.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/ro.owl



components/clo.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/clo.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/clo.owl



components/uberon.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/uberon/uberon-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/uberon.owl





components/fbbt.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/fbbt/fbbt-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/fbbt.owl



components/wbbt.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/wbbt/wbbt-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/wbbt.owl



components/ecto.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/ecto/ecto-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/ecto.owl



components/zfa.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/zfa/zfa-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/zfa.owl



components/maxo.owl: .FORCE
	@if [ $(IMP) = true ]; then $(ROBOT) merge -I http://purl.obolibrary.org/obo/maxo/maxo-base.owl \
	annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -o $@; fi
.PRECIOUS: components/maxo.owl







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


## ONTOLOGY: fao
## Copy of fao is re-downloaded whenever source changes
mirror/fao.trigger: $(SRC)

mirror/fao.owl: mirror/fao.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/fao.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: oba
## Copy of oba is re-downloaded whenever source changes
mirror/oba.trigger: $(SRC)

mirror/oba.owl: mirror/oba.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/oba.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: po
## Copy of po is re-downloaded whenever source changes
mirror/po.trigger: $(SRC)

mirror/po.owl: mirror/po.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/po.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: vt
## Copy of vt is re-downloaded whenever source changes
mirror/vt.trigger: $(SRC)

mirror/vt.owl: mirror/vt.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/vt.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: stato
## Copy of stato is re-downloaded whenever source changes
mirror/stato.trigger: $(SRC)

mirror/stato.owl: mirror/stato.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/stato.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: bfo
## Copy of bfo is re-downloaded whenever source changes
mirror/bfo.trigger: $(SRC)

mirror/bfo.owl: mirror/bfo.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/bfo.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

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


## ONTOLOGY: ncbitaxon-taxslim
## Copy of ncbitaxon-taxslim is re-downloaded whenever source changes
mirror/ncbitaxon-taxslim.trigger: $(SRC)

mirror/ncbitaxon-taxslim.owl: mirror/ncbitaxon-taxslim.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/ncbitaxon/subsets/taxslim.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: caro
## Copy of caro is re-downloaded whenever source changes
mirror/caro.trigger: $(SRC)

mirror/caro.owl: mirror/caro.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I $(URIBASE)/caro.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-ext
## Copy of uberon-ext is re-downloaded whenever source changes
mirror/uberon-ext.trigger: $(SRC)

mirror/uberon-ext.owl: mirror/uberon-ext.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/ext.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-zfa
## Copy of uberon-bridge-to-zfa is re-downloaded whenever source changes
mirror/uberon-bridge-to-zfa.trigger: $(SRC)

mirror/uberon-bridge-to-zfa.owl: mirror/uberon-bridge-to-zfa.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-zfa.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-ma
## Copy of uberon-bridge-to-ma is re-downloaded whenever source changes
mirror/uberon-bridge-to-ma.trigger: $(SRC)

mirror/uberon-bridge-to-ma.owl: mirror/uberon-bridge-to-ma.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-ma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-wbbt
## Copy of uberon-bridge-to-wbbt is re-downloaded whenever source changes
mirror/uberon-bridge-to-wbbt.trigger: $(SRC)

mirror/uberon-bridge-to-wbbt.owl: mirror/uberon-bridge-to-wbbt.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-wbbt.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-fbbt
## Copy of uberon-bridge-to-fbbt is re-downloaded whenever source changes
mirror/uberon-bridge-to-fbbt.trigger: $(SRC)

mirror/uberon-bridge-to-fbbt.owl: mirror/uberon-bridge-to-fbbt.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-fbbt.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-fma
## Copy of uberon-bridge-to-fma is re-downloaded whenever source changes
mirror/uberon-bridge-to-fma.trigger: $(SRC)

mirror/uberon-bridge-to-fma.owl: mirror/uberon-bridge-to-fma.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-fma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: uberon-bridge-to-nifstd
## Copy of uberon-bridge-to-nifstd is re-downloaded whenever source changes
mirror/uberon-bridge-to-nifstd.trigger: $(SRC)

mirror/uberon-bridge-to-nifstd.owl: mirror/uberon-bridge-to-nifstd.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/uberon-bridge-to-nifstd.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl-bridge-to-ma
## Copy of cl-bridge-to-ma is re-downloaded whenever source changes
mirror/cl-bridge-to-ma.trigger: $(SRC)

mirror/cl-bridge-to-ma.owl: mirror/cl-bridge-to-ma.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-ma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl-bridge-to-fma
## Copy of cl-bridge-to-fma is re-downloaded whenever source changes
mirror/cl-bridge-to-fma.trigger: $(SRC)

mirror/cl-bridge-to-fma.owl: mirror/cl-bridge-to-fma.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-fma.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl-bridge-to-wbbt
## Copy of cl-bridge-to-wbbt is re-downloaded whenever source changes
mirror/cl-bridge-to-wbbt.trigger: $(SRC)

mirror/cl-bridge-to-wbbt.owl: mirror/cl-bridge-to-wbbt.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-wbbt.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl-bridge-to-fbbt
## Copy of cl-bridge-to-fbbt is re-downloaded whenever source changes
mirror/cl-bridge-to-fbbt.trigger: $(SRC)

mirror/cl-bridge-to-fbbt.owl: mirror/cl-bridge-to-fbbt.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-fbbt.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

.PRECIOUS: mirror/%.owl


## ONTOLOGY: cl-bridge-to-zfa
## Copy of cl-bridge-to-zfa is re-downloaded whenever source changes
mirror/cl-bridge-to-zfa.trigger: $(SRC)

mirror/cl-bridge-to-zfa.owl: mirror/cl-bridge-to-zfa.trigger
	@if [ $(MIR) = true ] && [ $(IMP) = true ]; then $(ROBOT) convert -I http://purl.obolibrary.org/obo/uberon/bridge/cl-bridge-to-zfa.owl -o $@.tmp.owl && mv $@.tmp.owl $@; fi

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
	$(ROBOT) report -i $< --fail-on $(REPORT_FAIL_ON) --print 5 -o $@

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









update_repo:
	sh ../scripts/update_repo.sh

include mo.Makefile