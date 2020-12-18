class GamesModel {
  Map<String, List<SingleGameModel>> allGameLists;
  Map<String, String> sportsSectionTitlesAndImagesMap;
  String selectedSport;
}

class SingleGameModel {
  String gameID;
  String homeTeam;
  String awayTeam;
  String gameTime;
  SelectedWinner selectedWinner;

  SingleGameModel(this.gameID, this.homeTeam, this.awayTeam, this.gameTime,
      this.selectedWinner);
}

enum SelectedWinner { none, homeTeam, awayTeam }
