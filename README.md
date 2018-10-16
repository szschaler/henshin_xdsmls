# Henshin based xDSMLs for GEMOC Studio 

This repository contains an execution engine that implements support for operational semantics defined in graph-transformation systems (GTSs) specified in [Henshin](https://www.eclipse.org/henshin/). Details of the approach can be found in the publication listed at the end.

## Installation

1. Install [GEMOC Studio](http://gemoc.org/studio.html)
2. Run GEMOC Studio and install [Henshin](https://www.eclipse.org/henshin/) following their normal installation procedure
3. Clone this repository and import all projects into your GEMOC Studio
4. Clone one of the example repositories ([banking](https://github.com/szschaler/banking_language), [production line system](https://github.com/szschaler/pls_language)) and import all projects except the `.design`, `.henshin`, and the `.example` projects. 
5. Run a runtime instance of GEMOC Studio
6. Import the `.design`, `.henshin`, and the `.example` projects from the example project. Inspect them and follow the instructions in the example project readme to run the debugger.

## Publications

1. Steffen Zschaler: Adding a HenshinEngine to GEMOC Studio: An experience report. GEMOC Workshop 2018.
[pdf](http://www.steffen-zschaler.de/download.php?type=pdf&id=123) [slides](http://gemoc.org/pub/20181015-GEMOC18/gemoc18-zschaler-slides.pdf)
