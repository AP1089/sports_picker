import 'package:flutter/material.dart';
import 'package:sports_picker/core/framework/bloc_provider.dart';
import 'package:sports_picker/features/games/bloc/games_bloc.dart';
import 'package:sports_picker/features/games/model/games_model.dart';
import 'package:sports_picker/features/games/ui/games_strings.dart';
import 'package:sports_picker/theme/app_style.dart';

const _gamesStrings = GamesStrings();

class GamesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GamesBloc>(
        bloc: GamesBloc(),
        child: MaterialApp(
          home: GamesUI(),
        ));
  }
}

class GamesUI extends StatefulWidget {
  @override
  _GamesUIState createState() => _GamesUIState();
}

class _GamesUIState extends State<GamesUI> {
  GamesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<GamesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.requestGamesData();
    });
    return Scaffold(
      backgroundColor: AppStyle.backgroundBlack,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSportsActionImage(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                      children: <Widget>[
                        _buildSportSelector(),
                        _buildGameCardsListView(),
                      ],
                    ),
                childCount: 1),
          )
        ],
      ),
    );
  }

  Widget _buildSportsActionImage() {
    return SliverAppBar(
      backgroundColor: AppStyle.backgroundBlack,
      expandedHeight: MediaQuery.of(context).size.width * .55,
      iconTheme: IconThemeData.fallback(),
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Opacity(
            opacity: .9,
            child: StreamBuilder<String>(
                stream: _bloc.selectedSportsActionImageRequestPipe.stream,
                initialData: "",
                builder: (context, snapshot) {
                  if (snapshot.data.isNotEmpty) {
                    String image = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  ///TODO implement loading dial or shimmer
                  return Container();
                })),
      ),
    );
  }

  Widget _buildSportSelector() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 4.0,
          bottom: 0,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: StreamBuilder<Map<String, List<String>>>(
              stream: _bloc.sportsSectionTitlesRequestPipe.stream,
              initialData: {},
              builder: (context, snapshot) {
                if (snapshot.data.isNotEmpty) {
                  String _selectedSport = snapshot.data.keys.first;
                  List<String> _sportsSectionsList = snapshot.data.values.first;
                  return Container(
                    height: 40,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sportsSectionsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildSportTitleChip(
                              _selectedSport == _sportsSectionsList[index],
                              _sportsSectionsList[index]);
                        }),
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }

  Widget _buildSportTitleChip(bool sportSelected, String sport) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 8),
        child: InputChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: StadiumBorder(
                side: BorderSide(
                    width: 1.5,
                    color:
                        (sportSelected) ? AppStyle.green : AppStyle.darkGray)),
            backgroundColor: AppStyle.backgroundBlack,
            onSelected: (_) {
              _bloc.updateSelectedSportPipe.sink.add(sport);
            },
            label: Text(sport,
                style: (sportSelected)
                    ? AppStyle.titleTextStyleGreen
                    : AppStyle.titleTextStyleDarkGray)));
  }

  Widget _buildGameCardsListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: StreamBuilder<List<SingleGameModel>>(
            stream: _bloc.selectedGameCardsListRequestPipe.stream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.data.isNotEmpty) {
                List<SingleGameModel> _gameCardsList = snapshot.data;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _gameCardsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildAvailableGameCard(_gameCardsList[index]);
                  },
                );
              }
              ///TODO implement loading dial or shimmer
              return Container();
            }),
      ),
    );
  }

  Widget _buildAvailableGameCard(SingleGameModel gameCardModel) {
    return Column(
      children: [
        _buildGrayCenterHeaderWidget(gameCardModel.gameTime),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                color: AppStyle.backgroundBlack,
                elevation: 12,
                shadowColor: AppStyle.black,
                child: Column(
                  children: [
                    ClipPath(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: (gameCardModel.selectedWinner ==
                                            SelectedWinner.none)
                                        ? AppStyle.green
                                        : AppStyle.blue,
                                    width: 5))),
                        child: Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                Map<String, SelectedWinner> _selectedGameData =
                                    {
                                  gameCardModel.gameID: SelectedWinner.homeTeam
                                };
                                _bloc.updateSelectedGamePipe.sink
                                    .add(_selectedGameData);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCardLeftSideHeader(_gamesStrings.home),
                                  _buildTeamText(
                                      gameCardModel.homeTeam,
                                      gameCardModel.selectedWinner ==
                                          SelectedWinner.homeTeam),
                                ],
                              ),
                            ),
                            Divider(
                              color: (gameCardModel.selectedWinner ==
                                      SelectedWinner.none)
                                  ? AppStyle.green
                                  : AppStyle.blue,
                              thickness: 1,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                Map<String, SelectedWinner> _selectedGameData =
                                    {
                                  gameCardModel.gameID: SelectedWinner.awayTeam
                                };
                                _bloc.updateSelectedGamePipe.sink
                                    .add(_selectedGameData);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCardLeftSideHeader(_gamesStrings.away),
                                  _buildTeamText(
                                      gameCardModel.awayTeam,
                                      gameCardModel.selectedWinner ==
                                          SelectedWinner.awayTeam),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGrayCenterHeaderWidget(String time) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0, bottom: 4.0),
      child: Text(time,
          style: AppStyle.bodyTextStyleGray, textAlign: TextAlign.center),
    );
  }

  Widget _buildCardLeftSideHeader(String header) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0),
        child: Text(header, style: AppStyle.bodyTextStyleGray));
  }

  Widget _buildTeamText(String team, bool teamSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Text(team,
                  style: (teamSelected)
                      ? AppStyle.mediumTextStyleBlue
                      : AppStyle.mediumTextStyleGray),
            ),
          ),
          if (teamSelected)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.check_circle, color: AppStyle.blue, size: 25),
            )
        ],
      ),
    );
  }
}
