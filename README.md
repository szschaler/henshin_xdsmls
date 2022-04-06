# Henshin based xDSMLs for GEMOC Studio

This repository contains a concurrent execution engine that implements support for operational semantics defined in graph-transformation systems (GTSs) specified in [Henshin](https://www.eclipse.org/henshin/). Details of the approach can be found in the publication listed at the end.

## Installation

1. Install the nightly build of [GEMOC Studio](http://gemoc.org/studio.html)
2. Run GEMOC Studio and install [Henshin](https://www.eclipse.org/henshin/) following their normal installation procedure
3. For the moment, you will also need to import the following projects from the https://github.com/gemoc/gemoc-studio-execution-moccml repository into your workspace and check out the `concurrency-analysis` branch. This will eventually be resolved when these changes are correctly integrated into the latest GEMOC Studio version.
   - org.eclipse.gemoc.execution.concurrent.ccsljavaengine
   - org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui
   - org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api
4. Clone this repository and import all projects into your GEMOC Studio
5. Clone one of the example repositories ([banking](https://github.com/szschaler/banking_language), [production line system](https://github.com/szschaler/pls_language)) and import all projects except the `.design`, `.henshin`, and the `.example` projects.
6. Run a runtime instance of GEMOC Studio -> Go to Debug or Run Configurations: Eclipse Application: New_configuration. Make sure it's a new workspace. You may have to set a non-default working directory on the `Arguments` tab.
7. In the second instance of GEMOC Studio import the `.design`, `.henshin`, and the `.example` projects from the example project. Inspect them and follow the instructions in the example project readme to run the debugger.

## Features

Annotating any LHS node with `Target` will make the match of that node the target of the rule application for purposes of the GEMOC debugger. This will make for better representation in the GEMOC stack trace. Only LHS nodes and no multi-nodes can be annotated at this point. *Not annotating any node with `Target` may mean that Sirius diagrams do not update when stepping through a DSML model in the debugger.*

The engine integrates with GEMOC's concurrency strategies framework allowing filtering and exploration of the concurrency model dynamically throughout a debug session. A paper is under preparation and a video demo can be found here:

[![image](https://user-images.githubusercontent.com/7057319/112985703-6d30db00-9158-11eb-9669-77a6a1f900b4.png)](https://uncloud.univ-nantes.fr/index.php/s/dz5aM8FRrDMtz3c?dir=undefined&openfile=471125365)


## Publications

1. Steffen Zschaler: Adding a HenshinEngine to GEMOC Studio: An experience report. GEMOC Workshop 2018.
[pdf](http://www.steffen-zschaler.de/download.php?type=pdf&id=123) [slides](http://gemoc.org/pub/20181015-GEMOC18/gemoc18-zschaler-slides.pdf)
