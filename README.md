This repository contains the source for the top-level importer for the Monarch ontology

## Usage

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
