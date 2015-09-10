This repository contains the source for the top-level importer for the Monarch ontology

## Components

The top-level ontology is found in the file [monarch.owl](monarch.owl)

This imports a number of other ontologies. These will be imported over the web. The ontologies are managed in separate github repositories:

 * Phenotypes: [obophenotype/upheno](https://github.com/obophenotype/upheno)
    * [mammalian-phenotype-ontology](https://github.com/obophenotype/mammalian-phenotype-ontology/)
    * [human-phenotype-ontology](https://github.com/obophenotype/human-phenotype-ontology/)
 * Diseases: [monarch-initiative/monarch-disease-ontology](https://github.com/monarch-initiative/monarch-disease-ontology)

## Computational Usage

The ontology can be inspected directly using Protege or used computationally using the OWLAPI. The follow instructions are for developers of the ontology

See the Makefile for details. You will need owltools.

For local development, you can create a cache of all dependent ontologies:

```
make catalog-v001.xml
```

This creates:

 * `cache/` - a directory containing a mirrored copy of each imported ontology
 * `catalog-v001.xml` - an index connecting the ontology URIs in the import to files in `cache`

After this is completed, you can work with monarch.owl in a more efficient way, or work off-line.

For example:

```
owltools --use-catalog monarch.owl MY-STUFF-HERE
```

Alternatively, if you open monarch.owl in Protege, it should automatically use the catalog
