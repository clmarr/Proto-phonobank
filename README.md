# Proto-phonobank

In the [rules-table] we'll be storing a row for each rule in the relative chronology of sound change [cascade] between an [ancestor] language and a [descendant] language

## Coding decisions

### Etyma and cognacy

Etymon ID -- etyma referenced as (claimed to be) affected by a rule have their unique etymon ID in the pertinent column for that rule
the etymon ID points to a table
each etymon in this table is essentially a tuple: (source lexeme ID, descendant lexeme ID)
each of these lexeme IDs points its semantic concept in concepticon as well

COGNACY between two etyma can be extracted as the truth value for whether they point to the same lexeme as their source in this tuple. 

## Notation

Rule notation currently follows these conventions: https://github.com/clmarr/DiaSim/wiki/Cascade. 


## Actor-critic dynamic

One LLM [actor] extracts the relative chronology of rules from a PDF. 

The [actor] extracts the rule (input, output, context), etyma the source claims are affected, the source including page number.

The role of the other LLM, the [critic], is to address extraction [infidelities] -- an [infidelity] is where the content extracted by the actor does not actually faithfully represent what was in the source file.

The [critic] makes a [corrected] file where infidelities (except for [good-infidelities], see below) are corrected, as well as a [correction-report] that lists every [correction] mdae

A [good-infidelity] is one where, in fact, the [actor] was correcting an error in the source. E.g. a typo, or applying a sound law that the source never actually explicates. 

E.g. Pardess has "/ŋn/" for input "/gn/"; this is a rule that could have happened but Pardess never explicated this in the rule description. This rule is unnecessary. The actor extracted a rule whereby "/g/" was the input, and words affected where written with "gn". This is "good" but unfaithful. 

The [critic] notes these "good" [infidelities] by listing them in a separate output file. 

### Signals to critic 

For training the critic at this early stage, the following flags are used: "$$!!" signals something should be corrected. "$$:)" signals that the actor made no mistake for the associated rule block. 

