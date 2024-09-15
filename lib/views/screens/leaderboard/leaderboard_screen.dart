import 'package:english_wordle/views/utils/colors.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  static const String routeName = '/leaderbord';
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leaderboard'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Transform.translate(
                          offset: Offset(0, 40),
                          child: LeaderboardProfile(
                            rank: "2",
                            name: 'Meghan Jes...',
                            points: '40',
                            imageUrl:
                                'https://img.freepik.com/premium-photo/young-woman-profile-black-hoodie-sweatshirt-dark-black-background_164357-12162.jpg',
                          ))),
                  Expanded(
                      child: LeaderboardProfile(
                    rank: "1",
                    name: 'Bryan Wolf',
                    points: '43',
                    imageUrl:
                        'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-man-is-hiding-with-a-hood-on-a-black-background-image_2878055.jpg',
                  )),
                  Expanded(
                      child: Transform.translate(
                          offset: Offset(0, 40),
                          child: LeaderboardProfile(
                            name: 'Alex Turner',
                            points: '38',
                            rank: "3",
                            imageUrl:
                                'https://png.pngtree.com/background/20230525/original/pngtree-black-background-digital-photo-of-the-girl-with-hoodie-picture-image_2735503.jpg',
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LeaderboardProfile extends StatelessWidget {
  const LeaderboardProfile(
      {super.key,
      required this.rank,
      required this.name,
      required this.points,
      required this.imageUrl});

  final String rank;
  final String name;
  final String points;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCircleAvatar(),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            points + " pts",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Stack _buildCircleAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
              ),
              border: Border.all(color: MyColors.navy1, width: 4)),
        ),
        Positioned(
            bottom: -15,
            left: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: MyColors.navy1,
              radius: 14,
              child: Center(
                child: Text(
                  rank,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ))
      ],
    );
  }
}
