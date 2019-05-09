# Henshin based xDSMLs for GEMOC Studio

This repository contains a concurrent execution engine that implements support for operational semantics defined in graph-transformation systems (GTSs) specified in [Henshin](https://www.eclipse.org/henshin/). Details of the approach can be found in the publication listed at the end.

## Installation

1. Install the nightly build of [GEMOC Studio](http://gemoc.org/studio.html)
2. Run GEMOC Studio and install [Henshin](https://www.eclipse.org/henshin/) following their normal installation procedure
3. Install GEMOC Concurrent Engine from Help > Install Additional GEMOC Components.
4. Clone this repository and import all projects into your GEMOC Studio
5. Clone https://github.com/szschaler/henshin_xtext_adapter and import all projects.
6. Clone one of the example repositories ([banking](https://github.com/szschaler/banking_language), [production line system](https://github.com/szschaler/pls_language)) and import all projects except the `.design`, `.henshin`, and the `.example` projects.
7. Run a runtime instance of GEMOC Studio -> Go to Debug or Run Configurations: Eclipse Application: New_configuration. Make sure it's a new workspace. You may have to set a non-default working directory on the `Arguments` tab.
8. In the second instance of GEMOC Studio import the `.design`, `.henshin`, and the `.example` projects from the example project. Inspect them and follow the instructions in the example project readme to run the debugger.

## Features

Annotating any LHS node with `Target` will make the match of that node the target of the rule application for purposes of the GEMOC debugger. This will make for better representation in the GEMOC stack trace. Only LHS nodes and no multi-nodes can be annotated at this point.

The current version of the engine includes both the atomic steps version and the maximally concurrent rules(a maximum sequence of rules that can be run together). The feature can be disabled with `showSequenceRules` flag in the launcher.

## Publications

1. Steffen Zschaler: Adding a HenshinEngine to GEMOC Studio: An experience report. GEMOC Workshop 2018.
[pdf](http://www.steffen-zschaler.de/download.php?type=pdf&id=123) [slides](http://gemoc.org/pub/20181015-GEMOC18/gemoc18-zschaler-slides.pdf)
