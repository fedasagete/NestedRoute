import 'scenarios.dart';

/// Optional nearby practice, not a claim that these cover every prerequisite.
List<GameKind> basicsFor(LearningScenario scenario) {
  switch (scenario.id) {
    case 'discovery-fractionDivision':
      return [GameKind.fractionTiles, GameKind.sharing];
    case 'discovery-signedProducts':
      return [GameKind.numberLine, GameKind.equalGroups];
    case 'discovery-ratio':
      return [GameKind.equalGroups, GameKind.sharing];
    case 'discovery-pythagoras':
    case 'discovery-squareRoot':
      return [GameKind.areaGrid, GameKind.equalGroups];
    case 'discovery-circleAngles':
      return [GameKind.angleBuilder, GameKind.sharing];
    case 'discovery-inequality':
      return [GameKind.numberLine, GameKind.balance];
    case 'discovery-congruence':
    case 'discovery-englishNumbers':
      return [];
  }
  switch (scenario.kind) {
    case GameKind.balance:
      return [GameKind.numberLine, GameKind.equalGroups];
    case GameKind.fractionTiles:
      return [GameKind.sharing];
    case GameKind.areaGrid:
    case GameKind.similarity:
      return [GameKind.equalGroups];
    case GameKind.angleBuilder:
      return [GameKind.numberLine];
    case GameKind.volume:
      return [GameKind.areaGrid, GameKind.equalGroups];
    case GameKind.probability:
      return [GameKind.fractionTiles, GameKind.sets];
    case GameKind.data:
      return [GameKind.sharing];
    case GameKind.numberLine:
    case GameKind.equalGroups:
    case GameKind.sharing:
    case GameKind.sets:
      return [];
  }
}
