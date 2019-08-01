---
layout: ontology_detail
id: mo
title: Monarch Ontology
jobs:
  - id: https://travis-ci.org/monarch-initiative/monarch-ontology
    type: travis-ci
build:
  checkout: git clone https://github.com/monarch-initiative/monarch-ontology.git
  system: git
  path: "."
contact:
  email: 
  label: 
  github: 
description: Monarch Ontology is an ontology...
domain: stuff
homepage: https://github.com/monarch-initiative/monarch-ontology
products:
  - id: mo.owl
    name: "Monarch Ontology main release in OWL format"
  - id: mo.obo
    name: "Monarch Ontology additional release in OBO format"
  - id: mo.json
    name: "Monarch Ontology additional release in OBOJSon format"
  - id: mo/mo-base.owl
    name: "Monarch Ontology main release in OWL format"
  - id: mo/mo-base.obo
    name: "Monarch Ontology additional release in OBO format"
  - id: mo/mo-base.json
    name: "Monarch Ontology additional release in OBOJSon format"
dependencies:
- id: nbo
- id: pr
- id: go
- id: uberon
- id: ro
- id: chebi
- id: hsapdv
- id: cl
- id: mpath
- id: ncbitaxon-taxslim.owl
- id: go-plus
- id: so
- id: eco
- id: uberon-ext
- id: uberon-bridge-to-zfa.owl
- id: uberon/bridge/uberon-bridge-to-ma.owl
- id: uberon/bridge/uberon-bridge-to-fma.owl
- id: uberon/bridge/cl-bridge-to-zfa.owl
- id: uberon/bridge/cl-bridge-to-ma.owl
- id: uberon/bridge/cl-bridge-to-fma.owl
- id: uberon/bridge/uberon-bridge-to-nifstd.owl
- id: pato

tracker: https://github.com/monarch-initiative/monarch-ontology/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
activity_status: active
---

Enter a detailed description of your ontology here. You can use arbitrary markdown and HTML.
You can also embed images too.

