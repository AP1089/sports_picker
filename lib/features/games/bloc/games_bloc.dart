import 'dart:async';
import 'package:sports_picker/core/framework/bloc_provider.dart';
import 'package:sports_picker/features/games/api/games_response.dart';
import 'package:sports_picker/features/games/api/games_service.dart';
import 'package:sports_picker/features/games/model/games_model.dart';

class GamesBloc extends Bloc {
  GamesModel _model = GamesModel();

  final selectedSportsActionImageRequestPipe =
      StreamController<String>.broadcast();
  final sportsSectionTitlesRequestPipe =
      StreamController<Map<String, List<String>>>.broadcast();
  final selectedGameCardsListRequestPipe =
      StreamController<List<SingleGameModel>>.broadcast();
  final updateSelectedGamePipe =
      StreamController<Map<String, SelectedWinner>>.broadcast();
  final updateSelectedSportPipe = StreamController<String>.broadcast();

  GamesBloc() {
    updateSelectedGamePipe.stream
        .listen((gameData) => _updateSelectedGame(gameData));
    updateSelectedSportPipe.stream
        .listen((sport) => _updateSelectedSport(sport));
  }

  Future<void> requestGamesData() async {
    GamesService _gamesService = GamesService();
    GamesResponse response = await _gamesService.fetchData();
    response.allGamesList.forEach((game) {
      if (_model.allGameLists.containsKey(game.sport)) {
        _model.allGameLists[game.sport].add(SingleGameModel(
            game.gameId,
            game.actionImage,
            game.homeTeam,
            game.awayTeam,
            game.gameTime,
            SelectedWinner.none));
      } else {
        List<SingleGameModel> _newSportGameList = [
          SingleGameModel(game.gameId, game.actionImage, game.homeTeam,
              game.awayTeam, game.gameTime, SelectedWinner.none)
        ];
        _model.allGameLists[game.sport] = _newSportGameList;
      }
    });

    _updateSelectedSport(_model.allGameLists.keys.first);
  }

  void _updateSelectedSport(String sport) {
    _model.selectedSport = sport;
    selectedSportsActionImageRequestPipe.sink
        .add(_model.allGameLists[_model.selectedSport].first.actionImage);
    sportsSectionTitlesRequestPipe.sink
        .add({_model.selectedSport: _model.allGameLists.keys.toList()});
    selectedGameCardsListRequestPipe.sink
        .add(_model.allGameLists[_model.selectedSport]);
  }

  void _updateSelectedGame(Map<String, SelectedWinner> gameData) {
    _model.allGameLists[_model.selectedSport].forEach((game) {
      if (game.gameID == gameData.keys.first) {
        if (game.selectedWinner == gameData.values.first) {
          game.selectedWinner = SelectedWinner.none;
        } else {
          game.selectedWinner = gameData.values.first;
        }
      }
    });
    selectedGameCardsListRequestPipe.sink
        .add(_model.allGameLists[_model.selectedSport]);
  }

  void dispose() {
    selectedSportsActionImageRequestPipe.close();
    sportsSectionTitlesRequestPipe.close();
    selectedGameCardsListRequestPipe.close();
    updateSelectedGamePipe.close();
    updateSelectedSportPipe.close();
  }
}
