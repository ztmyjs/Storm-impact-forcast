# Development Guide

## Installation
Follow the guide at https://docs.flutter.dev/get-started/install for your respective OS. Once installed, run `flutter pub get` in the root directory of the folder. 
## How complex data and dependent components work
The StormImpact dashboard has a lot of moving parts, and because data is not two way bound in Flutter, the `Provider` package is used to manage state between components that depend on each other. 

### Providers
The provider package uses `ChangeNotifierProviders` to create contexts for components that are using the provider package to share state. The purpose of this is to create a context that is shared between the components of the provider. Typically, a provider is used as the alias with which you call a chain of dependent components. 

### Consumers
Consumers are what allows the state to be shared between dependent components. A consumer is, in essence, a source of truth for a component that uses the `Provider` package. A consumer cascades changes in state when something changes in any of the dependent components through the use of events. 

### Models
To enable consumers to share data between components, models are created as a way to store the global state of that provider component. For example, `map_model_base` and its subclasses store the state of the map and the cross model aggregation table of that map. 

State variables are defined at the top of a model file and methods within the model modify those state variables. To update state for all consumers using that model, the `notifyListeners()` method is used to send an event to said consumers to rerender their data.

```dart
void doStuff() {
  do something to state
  notifyListeners();
}

```


## Map
The StormImpact Dashboard’s map is the default page that the user sees when they load into the app. There are 2 different maps: `OperatingCompanyMap.dart` and `CompanyMap.dart`. Each map has many different features like: Displaying polygons, Cross Model Aggregation Tables, and of course, typical map behavior. 
MapModels

Each map model’s job is to be a source of truth for the polygons and cross model aggregation tables within each map. When Flutter first renders a map component, the associated model is instantiated, and loads the map data and reports for that map component. 
### Polygons

The operating company polygons are color coded based on the amount of customers an operating company has. The legend contains the breakdown of all the colors that a polygon can be. They are loaded when a MapModel is instantiated through the use of `lib/api/back_end.dart`, and the GeoJson is auto parsed by the FlutterMapsParser library and the polygon creation can be found in OperatingCompanyParser.dart’s `_polygonCreationCallback` method.

Each polygon represents an operating company and has a hover event. The hover event is defined as an event on the associated map, and the code to implement the highlighting can be found in `MapModelBase.dart`. This method can be overridden in files that inherit from `MapModelBase`.
#### InteractivePolygon
`InteractivePolygon` is a class that encompasses the default polygon class provided by the FlutterMaps library. Within it is the code to check whether or not a user’s click or cursor is within a polygon’s boundaries.
## Cross Model Aggregation Tables

The cross model aggregation table is an essential feature in the map screens. With the cross model aggregation table, users are able to view different features of the data for each company or operating company. The two implementations can be found in `operating_company_cross_model_aggregation_table.dart` and `company_cross_model_aggregation_table.dart`. Each of these table classes has a class within it that defines how each data table is rendered. 

The data is loaded through the associated MapModel. Each aggregation is done in getRows which can be found in `map_model_base.dart`. What `getRows` does is returns a future value of the aggregations, and dynamically adjusts the table based on when the user is interacting with the map. On first load, the `shouldMutate` flag is set to false, else it’s set to true. 

### Table Model Units
To facilitate development, `Customer`, `Outage`, `Trouble`, and `UnitModelBase` classes were created as a way for data tables to map data to rows. Each Table Model Unit class acts as a 1:1 representation of each entry in the model report. Therefore, each table model unit contains a final variable field for each of the data features that are in each `report.json`, and the shared features are declared in `UnitModelBase`. 
## Graphs
StormImpact dashboard’s graphs are implemented using the `SyncFusion` library. The `Syncfusion` library requires a graph data source as a x, y mapper for the graph. There is a standard implementation for a data source found in `GraphDataSource.dart`.
### Loading Data
The two biggest challenges with loading many JSON files with many features in components is `setState` function bloat and DRY(Don’t repeat yourself) violations. As a result, we had to create a callback parameter to the `parseStandard[Model]Report` in back_end.dart to leverage the code we’ve already written to parse the reports for the cross model aggregation tables.

### The general workflow for creating a graph
1. Decide how many dropdowns need to be created
2. Create setState function to load in the data
3. Create the _create[Model]Data functions to massage the data into an array of graph data sources
4. Create the get charts method which conditionally creates the graph type based on the model type state that was set from user actions.

A good example to base future graphs off of is `company_box_and_whisker.dart`.

## Backend
Because we were tasked with just creating a front end for StormImpact, there were liberties taken to load in the data. `Back_end.dart` is a file where all future api calls from StormImpact should go. Right now, the paths of the reports and geojsons are being used to load in the data in the respective parse methods, but in the future, they can be substituted with HTTP requests.

## Constants
Constants are defined in `Constants.dart`

