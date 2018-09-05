## Design doc
Followed VIPER design pattern but not exactly using it the same way base on the use case. Also used protocols where possible to ensure lose coupling and enable reusable module

### rootVC 
which contains Both Calendar View and AgendaView (and the weather view)

## Interactors
Consuming Entities from other data sources and producing viewModels.

### Presenter
which contains reference of interactors and viewModels.
It serves to fetch viewModels using interactors as well as bind the viewModels to views.
It was meant to be two presenters for each calendar and agenda views to ensure even less coupling. However since the functionality of the two views are too similar, it was used as a presenter for both views.

