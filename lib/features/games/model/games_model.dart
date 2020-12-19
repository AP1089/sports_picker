class GamesModel {
  Map<String, List<SingleGameModel>> allGameLists = {};
  String selectedSport;
}

class SingleGameModel {
  String gameID;
  String actionImage;
  String homeTeam;
  String awayTeam;
  String gameTime;
  SelectedWinner selectedWinner;

  SingleGameModel(this.gameID, this.actionImage, this.homeTeam, this.awayTeam,
      this.gameTime, this.selectedWinner);
}

enum SelectedWinner { none, homeTeam, awayTeam }
