class GamesResponse {
  List<SingleGameResponse> allGamesList;

  GamesResponse({
    this.allGamesList,
  });

  factory GamesResponse.fromJson(Map<String, dynamic> json) {
    return GamesResponse(
        allGamesList: json['games']
            .map<SingleGameResponse>(
                (json) => SingleGameResponse.fromJson(json))
            .toList());
  }
}

class SingleGameResponse {
  String sport;
  String actionImage;
  String gameId;
  String gameTime;
  String homeTeam;
  String awayTeam;

  SingleGameResponse(
      {this.sport,
      this.actionImage,
      this.gameId,
      this.gameTime,
      this.homeTeam,
      this.awayTeam});

  factory SingleGameResponse.fromJson(Map<String, dynamic> json) {
    return SingleGameResponse(
        sport: json['sport'],
        actionImage: json['actionImage'],
        gameId: json['gameId'],
        gameTime: json['gameTime'],
        homeTeam: json['homeTeam'],
        awayTeam: json['awayTeam']);
  }
}
