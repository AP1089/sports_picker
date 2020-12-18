import 'dart:async';
import 'package:sports_picker/core/framework/bloc_provider.dart';
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
        .listen((gameData) => _updateAGameToSelected(gameData));
    updateSelectedSportPipe.stream
        .listen((sport) => _updateSelectedSport(sport));
  }

  void requestGamesData() {
    /// TODO Make service call to retrieve game data and parse it into the
    /// classes below. Using mocked data for now:
    Map<String, List<SingleGameModel>> _allGamesList = {
      "MLB": [
        SingleGameModel("123456789", "REDS", "YANKEES", "Jan 04, 08:00AM EST",
            SelectedWinner.none),
        SingleGameModel("987654321", "METS", "DODGERS", "Jan 04, 10:30AM EST",
            SelectedWinner.none),
        SingleGameModel("123459876", "CUBS", "CARDINALS", "Jan 04, 12:00PM EST",
            SelectedWinner.none),
        SingleGameModel("123452876", "GIANTS", "ANGELS", "Jan 04, 01:30PM EST",
            SelectedWinner.none)
      ],
      "NBA": [
        SingleGameModel("4839506000", "LAKERS", "CAVS", "Jan 05, 08:00AM EST",
            SelectedWinner.none),
        SingleGameModel("223435679", "KNICKS", "NETS", "Jan 05, 10:30AM EST",
            SelectedWinner.none),
        SingleGameModel("0090008765", "WARRIORS", "ROCKETS",
            "Jan 05, 12:00PM EST", SelectedWinner.none),
        SingleGameModel("009000d765", "BUCKS", "SUNS", "Jan 05, 01:30PM EST",
            SelectedWinner.none)
      ],
      "NFL": [
        SingleGameModel("838383832", "BROWNS", "BENGALS", "Jan 06, 08:00AM EST",
            SelectedWinner.none),
        SingleGameModel("010101020", "COWBOYS", "PACKERS",
            "Jan 06, 10:30AM EST", SelectedWinner.none),
        SingleGameModel("110038383", "FALCONS", "PATRIOTS",
            "Jan 06, 12:00PM EST", SelectedWinner.none),
        SingleGameModel("210038383", "LIONS", "PANTHERS", "Jan 06, 01:30PM EST",
            SelectedWinner.none)
      ],
      "EPL": [
        SingleGameModel("838383832", "ARSENAL", "LIVERPOOL",
            "Jan 07, 08:00AM EST", SelectedWinner.none),
        SingleGameModel("010101020", "ASTON VILLA", "MANCHESTER UNITED",
            "Jan 07, 10:30AM EST", SelectedWinner.none),
        SingleGameModel("110038383", "CHELSEA", "EVERTON",
            "Jan 07, 12:00PM EST", SelectedWinner.none),
        SingleGameModel("110038389", "TOTTENHAM", "WEST HAM",
            "Jan 07, 01:30PM EST", SelectedWinner.none)
      ]
    };
    Map<String, String> _sportsSectionTitlesAndImagesMap = {
      "MLB": "assets/images/mlb_action_image.jpeg",
      "NBA": "assets/images/nba_action_image.jpg",
      "NFL": "assets/images/nfl_action_image.jpg",
      "EPL": "assets/images/fifa_action_image.jpg"
    };

    _model.allGameLists = _allGamesList;
    _model.sportsSectionTitlesAndImagesMap = _sportsSectionTitlesAndImagesMap;

    _updateSelectedSport(_model.allGameLists.keys.first);
  }

  void _updateSelectedSport(String sport) {
    _model.selectedSport = sport;
    selectedSportsActionImageRequestPipe.sink
        .add(_model.sportsSectionTitlesAndImagesMap[_model.selectedSport]);
    sportsSectionTitlesRequestPipe.sink.add({
      _model.selectedSport: _model.sportsSectionTitlesAndImagesMap.keys.toList()
    });
    selectedGameCardsListRequestPipe.sink
        .add(_model.allGameLists[_model.selectedSport]);
  }

  void _updateAGameToSelected(Map<String, SelectedWinner> gameData) {
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
