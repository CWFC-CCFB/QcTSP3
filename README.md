[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0) [![R-CMD-check](https://github.com/CWFC-CCFB/QcTSP3/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CWFC-CCFB/QcTSP3/actions/workflows/R-CMD-check.yaml)

The QcTSP3 package
=======================

## Introduction

The QcTSP3 package contains a clean version of Quebec TSP data from the third campaign of the provincial inventory.

The original data was produced and made freely available online
at https://www.donneesquebec.ca/recherche/dataset/placettes-echantillons-temporaires-3e-inventaire-1992-2003 by Direction des inventaires forestiers
of Ministère des Ressources naturelles et des Forêts du Québec. The original data is published under a CC-BY 4.0 license. 

## License

This package is licensed under the LGPL-3. 

## How to use it

The package can be installed using the remotes package:

~~~R
library(remotes)
remotes::install_github("CWFC-CCFB/QcTSP3")
~~~

To get access to the four tables of the database:

~~~R
QcTSP3::restoreQcTSP3Data()
~~~

This will create a list object called QcTSP4Data in the global environment. This list contains:

- plots: the list of plots 
- sites: some site information recorded in those plots 
- photoInterpretedStands: some site information recorded through photo-interpretation 
- trees: the tallied trees 
- studyTrees: the study trees (a subsample of trees) 
- saplings: the tallied saplings

Further information on the fields and their values can be found at 

https://diffusion.mffp.gouv.qc.ca/Diffusion/DonneeGratuite/Foret/DONNEES_FOR_ECO_SUD/Placettes_temporaires_3e/1-Documentation/DICTIONNAIRE_PLACETTE.xlsx

The inventory protocol is available at

https://mffp.gouv.qc.ca/documents/forets/inventaire/norme_inventaire_PET_plus7m_3e_inventaire.pdf

