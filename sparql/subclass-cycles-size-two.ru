PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

DELETE {
  ?sub rdfs:subClassOf ?intermediate .
  ?intermediate rdfs:subClassOf ?sub .
}
INSERT {
  ?sub owl:equivalentClass ?intermediate .
}
WHERE {
  ?sub rdfs:subClassOf ?intermediate .
  ?intermediate rdfs:subClassOf ?sub .
}